#!/usr/bin/env bash
# Install Ubuntu packages: the base system from apt (packages/apt.txt), and all CLI tools
# from Homebrew (packages/common.txt + brew.txt), the same lists macOS uses.
# No extra fonts: ghostty uses Ubuntu Sans Mono and its built-in Nerd Font icons.
# Safe to rerun; already installed packages are skipped.
#
#   setup/ubuntu.sh [--extras] [--dry-run]

set -euo pipefail
source "$(dirname "$0")/lib.sh"
parse_flags "$@"

is_ubuntu || die "this script is for Ubuntu"

BREW_PREFIX=/home/linuxbrew/.linuxbrew

info "Updating system"
run sudo apt-get update -q
run sudo apt-get upgrade -y -q

info "Installing apt packages"
# shellcheck disable=SC2046  # word splitting is intended: one package per word
run sudo apt-get install -y -q $(read_list "$PACKAGES/apt.txt")

# Homebrew (needs build-essential, curl, file, git and procps from apt)
if [ -x "$BREW_PREFIX/bin/brew" ]; then
  ok "Homebrew is installed"
else
  info "Installing Homebrew"
  run env NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
[ -x "$BREW_PREFIX/bin/brew" ] && eval "$("$BREW_PREFIX/bin/brew" shellenv)"

info "Updating Homebrew"
run brew analytics off
run brew update
run brew upgrade

lists_brew="$PACKAGES/common.txt $PACKAGES/brew.txt"
[ "$EXTRAS" = 1 ] && lists_brew="$lists_brew $PACKAGES/extras-brew.txt"

info "Installing Homebrew formulae"
# shellcheck disable=SC2046,SC2086  # word splitting is intended: one package per word
run brew install $(read_list $lists_brew)
run brew cleanup --prune=all

info "Cleaning up apt cache"
run sudo apt-get autoremove -y -q
run sudo apt-get clean
