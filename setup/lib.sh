# shellcheck shell=bash disable=SC2034  # variables are used by the scripts that source this
# Shared helpers for the setup scripts. Source it, don't run it:
#   source "$(dirname "$0")/lib.sh"
#   parse_flags "$@"
#
# Written for bash 3.2 (the macOS default), so no mapfile or associative arrays.

DOTFILES="$HOME/Documents/github/dotfiles"
NVIM_CONFIG="$HOME/Documents/github/nvim"
PACKAGES="$DOTFILES/packages"

# Flags, set by parse_flags (`install` passes its own arguments on to each script)
DRY_RUN=0
EXTRAS=0
DEFAULTS=0
KEYREMAP=0

# Steps that failed but didn't stop the script; see try() and report_failures()
FAILED=""

# ----------------------------------------
# - Output                               -
# ----------------------------------------

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$*"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

# Report an action that was just done; with --dry-run it was only printed, so say "would"
did() {
  if [ "$DRY_RUN" = 1 ]; then
    printf '  \033[2m→ would %s\033[0m\n' "$*"
  else
    ok "$*"
  fi
}

# ----------------------------------------
# - Flags                                -
# ----------------------------------------

usage() {
  cat <<EOF
Usage: $(basename "$0") [--extras] [--defaults] [--keyremap] [--dry-run]

  --extras     also install the optional packages (packages/extras-*.txt)
  --defaults   macOS: also apply the system settings in macos/defaults.sh
  --keyremap   macOS: also install the key remap for non-US keyboards (see macos/README.md)
  --dry-run    print what would change without changing anything
EOF
}

parse_flags() {
  while [ $# -gt 0 ]; do
    case "$1" in
      --extras)   EXTRAS=1 ;;
      --defaults) DEFAULTS=1 ;;
      --keyremap) KEYREMAP=1 ;;
      --dry-run)  DRY_RUN=1 ;;
      -h|--help)  usage; exit 0 ;;
      *)          usage >&2; die "unknown option: $1" ;;
    esac
    shift
  done
}

# ----------------------------------------
# - Platform                             -
# ----------------------------------------

is_macos()  { [ "$(uname)" = "Darwin" ]; }
is_linux()  { [ "$(uname)" = "Linux" ]; }
is_arch()   { [ -f /etc/arch-release ]; }
is_ubuntu() { grep -qx 'ID=ubuntu' /etc/os-release 2>/dev/null; }
has()       { command -v "$1" >/dev/null 2>&1; }

# Put Homebrew on PATH if it's installed (Apple Silicon, Intel Mac, Linux).
# Each setup script runs in its own process, so every script needs this.
load_brew() {
  local brew
  for brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [ -x "$brew" ]; then
      eval "$("$brew" shellenv)"
      return 0
    fi
  done
  return 0
}

# Install Homebrew (macOS and Ubuntu). Downloads the installer first, so a failed
# download stops here instead of running an empty script.
install_brew() {
  local script
  script="$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" ||
    die "could not download the Homebrew installer"
  NONINTERACTIVE=1 /bin/bash -c "$script"
  load_brew
}

# ----------------------------------------
# - Actions                              -
# ----------------------------------------

# Run a command, or only print it with --dry-run
run() {
  if [ "$DRY_RUN" = 1 ]; then
    printf '  \033[2m[dry-run]\033[0m %s\n' "$*"
  else
    "$@"
  fi
}

# Run a step that may fail without stopping the script: try "<step name>" <command...>
# Failures are collected and reported by report_failures at the end.
try() {
  local step="$1"
  shift
  if ! run "$@"; then
    warn "failed: $step (continuing)"
    FAILED="$FAILED
  - $step"
  fi
}

# Call at the end of a script: list failed steps and exit non-zero if there were any
report_failures() {
  if [ -n "$FAILED" ]; then
    printf '\033[1;31mThese steps failed:\033[0m%s\n' "$FAILED" >&2
    exit 1
  fi
}

# Append a line to a root-owned file (e.g. /etc/shells), starting on a new line
# even if the file doesn't end with one
append_root() {
  local file="$1" line="$2"
  # shellcheck disable=SC2016  # $1/$2 are expanded by the inner sh, not here
  run sudo sh -c '
    if [ -s "$1" ] && [ -n "$(tail -c 1 "$1")" ]; then echo >> "$1"; fi
    printf "%s\n" "$2" >> "$1"
  ' _ "$file" "$line"
}

# Print the packages in one or more list files, skipping comments and blank lines.
# Missing files are ignored, so optional lists don't need to exist.
read_list() {
  local file
  for file in "$@"; do
    [ -f "$file" ] || continue
    sed -e 's/#.*//' -e 's/[[:space:]]*$//' -e '/^$/d' "$file"
  done
}

# Symlink $1 (in the repo) to $2 (in $HOME). Safe to rerun:
#   - already correct           -> nothing to do
#   - link into this repo       -> replaced (e.g. an old path)
#   - anything else in the way  -> moved to <name>.bak-<date> first, nothing is deleted
link() {
  local src="$1" dst="$2"

  [ -e "$src" ] || { warn "skipping $dst: $src does not exist"; return 0; }

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    ok "$dst"
    return 0
  fi

  # $dst is the repo file itself, reached through a linked parent folder
  # (e.g. ~/.config/tmux -> repo/tmux); moving it would move the repo file
  if [ ! -L "$dst" ] && [ "$dst" -ef "$src" ]; then
    warn "$dst is the repo file itself (a parent folder links into the repo); fix by hand"
    return 0
  fi

  if [ -L "$dst" ]; then
    case "$(readlink "$dst")" in
      "$DOTFILES"/*|"$NVIM_CONFIG"|"$NVIM_CONFIG"/*) run rm "$dst" ;;
      *) backup "$dst" ;;
    esac
  elif [ -e "$dst" ]; then
    backup "$dst"
  fi

  run mkdir -p "$(dirname "$dst")"
  run ln -s "$src" "$dst"
  did "link $dst -> $src"
}

# Move $1 aside to <name>.bak-<date>
backup() {
  local path="$1" bak
  bak="$path.bak-$(date +%Y%m%d-%H%M%S)"
  warn "moving existing $path to $bak"
  run mv "$path" "$bak"
}

# Remove broken links directly in folder $1 that point into this repo,
# e.g. left behind when a config folder is removed from the repo.
# Only checks the folder itself, not subfolders.
prune_links() {
  local dir="$1" l
  [ -d "$dir" ] || return 0
  find "$dir" -maxdepth 1 -type l | while read -r l; do
    case "$(readlink "$l")" in
      "$DOTFILES"/*)
        if [ ! -e "$l" ]; then
          run rm "$l"
          did "remove broken link $l"
        fi
        ;;
    esac
  done
}

# Clone a git repo into $2, or fast-forward it if it is already there
clone_or_pull() {
  local url="$1" dir="$2"
  if [ -d "$dir/.git" ]; then
    try "update $dir" git -C "$dir" pull --ff-only --quiet
    did "update $dir"
  else
    try "clone $url" git clone --quiet "$url" "$dir"
    did "clone $url"
  fi
}

load_brew
