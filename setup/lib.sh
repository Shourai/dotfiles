# shellcheck shell=bash disable=SC2034  # variables are used by the scripts that source this
# Shared helpers for the setup scripts. Source it, don't run it:
#   source "$(dirname "$0")/lib.sh"
#   parse_flags "$@"
#
# Written for bash 3.2 (the macOS default), so no mapfile or associative arrays.

DOTFILES="$HOME/Documents/github/dotfiles"
NVIM_CONFIG="$HOME/Documents/github/nvim"
PACKAGES="$DOTFILES/packages"

# Flags; also inherited from the environment when called from `install`
DRY_RUN="${DRY_RUN:-0}"
EXTRAS="${EXTRAS:-0}"
DEFAULTS="${DEFAULTS:-0}"

# ----------------------------------------
# - Output                               -
# ----------------------------------------

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$*"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

# ----------------------------------------
# - Flags                                -
# ----------------------------------------

usage() {
  cat <<EOF
Usage: $(basename "$0") [--extras] [--defaults] [--dry-run]

  --extras     also install the optional packages (packages/extras-*.txt)
  --defaults   also apply macOS system settings (macos/defaults.sh)
  --dry-run    print what would change without changing anything
EOF
}

parse_flags() {
  while [ $# -gt 0 ]; do
    case "$1" in
      --extras)   EXTRAS=1 ;;
      --defaults) DEFAULTS=1 ;;
      --dry-run)  DRY_RUN=1 ;;
      -h|--help)  usage; exit 0 ;;
      *)          usage >&2; die "unknown option: $1" ;;
    esac
    shift
  done
  export DRY_RUN EXTRAS DEFAULTS
}

# ----------------------------------------
# - Platform                             -
# ----------------------------------------

is_macos() { [ "$(uname)" = "Darwin" ]; }
is_arch()  { [ -f /etc/arch-release ]; }
has()      { command -v "$1" >/dev/null 2>&1; }

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
#   - already correct      -> nothing to do
#   - other or broken link -> replaced
#   - real file or folder  -> moved to <name>.bak-<date> first
link() {
  local src="$1" dst="$2"

  [ -e "$src" ] || { warn "skipping $dst: $src does not exist"; return 0; }

  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    ok "$dst"
    return 0
  fi

  if [ -L "$dst" ]; then
    run rm "$dst"
  elif [ -e "$dst" ]; then
    local backup
    backup="$dst.bak-$(date +%Y%m%d-%H%M%S)"
    warn "backing up existing $dst to $backup"
    run mv "$dst" "$backup"
  fi

  run mkdir -p "$(dirname "$dst")"
  run ln -s "$src" "$dst"
  ok "$dst -> $src"
}

# Remove broken links in folder $1 that point into this repo,
# e.g. left behind when a config folder is removed from the repo.
prune_links() {
  local dir="$1" l target
  [ -d "$dir" ] || return 0
  find "$dir" -maxdepth 1 -type l | while read -r l; do
    target="$(readlink "$l")"
    case "$target" in
      "$DOTFILES"*)
        if [ ! -e "$l" ]; then
          run rm "$l"
          ok "removed broken link $l"
        fi
        ;;
    esac
  done
}

# Clone a git repo into $2, or fast-forward it if it is already there
clone_or_pull() {
  local url="$1" dir="$2"
  if [ -d "$dir/.git" ]; then
    run git -C "$dir" pull --ff-only --quiet
    ok "updated $dir"
  else
    run git clone --quiet "$url" "$dir"
    ok "cloned $url"
  fi
}
