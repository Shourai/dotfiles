#!/usr/bin/env bash
# Install Ubuntu packages: the base system from apt (packages/apt.txt), and all CLI tools
# from Homebrew (packages/common.txt + brew.txt), the same lists macOS uses.
# Also upgrades the system (apt upgrade) and everything in Homebrew (brew upgrade), and sets
# the GNOME keyboard shortcuts (ubuntu/shortcuts.sh).
# Safe to rerun; already installed packages are skipped.
#
#   setup/ubuntu.sh [--dry-run]

set -euo pipefail
source "$(dirname "$0")/lib.sh"
parse_flags "$@"

is_ubuntu || die "this script is for Ubuntu"

BREW_ZSH=/home/linuxbrew/.linuxbrew/bin/zsh

# Written for 26.04 LTS
version="$(. /etc/os-release && echo "$VERSION_ID")"
if [ "$(printf '%s\n26.04\n' "$version" | sort -V | head -1)" != "26.04" ]; then
  warn "Ubuntu $version is older than 26.04; some packages may be missing or too old"
fi

# Never stop for configuration prompts; keep local changes to system config files
apt=(sudo env DEBIAN_FRONTEND=noninteractive apt-get -y -q -o Dpkg::Options::=--force-confold)

info "Updating system"
try "apt update" "${apt[@]}" update
try "apt upgrade" "${apt[@]}" upgrade

info "Installing apt packages"
# shellcheck disable=SC2046  # word splitting is intended: one package per word
try "apt packages (packages/apt.txt)" "${apt[@]}" install $(read_list "$PACKAGES/apt.txt")

info "Installing Snaps"
# (not piped into the loop: the loop must run in this shell so try() can record failures)
while read -r snap; do
  # shellcheck disable=SC2086  # "<name> <options>" splits into arguments
  try "snap install $snap" sudo snap install $snap
done < <(read_list "$PACKAGES/snap.txt")
# An older ghostty from apt would come first on PATH (/usr/bin before /snap/bin)
if [ -x /usr/bin/ghostty ]; then
  warn "ghostty from apt (1.3) is installed too and would be used instead of the Snap: sudo apt remove ghostty"
fi

# Homebrew (needs build-essential, curl, file, git and procps from apt)
if has brew; then
  ok "Homebrew is installed"
else
  info "Installing Homebrew"
  run install_brew
fi

info "Updating Homebrew"
try "brew analytics off" brew analytics off
try "brew update" brew update
try "brew upgrade" brew upgrade

info "Installing Homebrew formulae"
# shellcheck disable=SC2046  # word splitting is intended: one package per word
try "brew formulae" brew install $(read_list "$PACKAGES/common.txt" "$PACKAGES/brew.txt")
try "brew cleanup" brew cleanup --prune=all

# The login shell is Homebrew's zsh (setup/zsh.sh). If an upgrade broke it, switch back
# to apt's zsh now, so logging in keeps working.
login_shell="$(getent passwd "$(id -un)" | cut -d: -f7)"
if [ "$login_shell" = "$BREW_ZSH" ] && [ "$DRY_RUN" = 0 ] && ! "$BREW_ZSH" -c 'exit 0' 2>/dev/null; then
  warn "Homebrew's zsh doesn't start; switching the login shell back to /usr/bin/zsh"
  try "chsh to /usr/bin/zsh" sudo chsh -s /usr/bin/zsh "$(id -un)"
fi

# GNOME keyboard shortcuts (ghostty + tmux on Ctrl+Alt+T etc.); needs the GNOME session
if [ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ] && [ -x /usr/bin/gsettings ]; then
  info "Setting GNOME keyboard shortcuts"
  try "ubuntu/shortcuts.sh" bash "$DOTFILES/ubuntu/shortcuts.sh"
else
  warn "no GNOME session: run ubuntu/shortcuts.sh from a terminal on the desktop to set the shortcuts"
fi

info "Cleaning up apt cache"
try "apt autoremove" "${apt[@]}" autoremove
try "apt clean" "${apt[@]}" clean

report_failures
