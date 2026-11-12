#!/usr/bin/env bash
# Install macOS packages from packages/*.txt with Homebrew; optionally the key remap
# (--keyremap).
# Also upgrades everything Homebrew manages (brew upgrade) and clears its cache.
# Safe to rerun; already installed packages are skipped.
#
#   setup/macos.sh [--keyremap] [--dry-run]

set -euo pipefail
source "$(dirname "$0")/lib.sh"
parse_flags "$@"

is_macos || die "this script is for macOS"

# Homebrew (normally already installed by `install`)
if ! has brew; then
  info "Installing Homebrew"
  run install_brew
fi

info "Updating Homebrew"
try "brew analytics off" brew analytics off
try "brew update" brew update
try "brew upgrade" brew upgrade

lists_brew=("$PACKAGES/common.txt" "$PACKAGES/brew.txt" "$PACKAGES/brew-macos.txt")

# shellcheck disable=SC2046  # only package names are intentionally split, not list filenames
{
  info "Installing formulae"
  try "brew formulae" brew install $(read_list "${lists_brew[@]}")

  # --adopt: take over apps that were installed by hand (e.g. from a .dmg) instead of failing
  info "Installing casks"
  try "brew casks" brew install --cask --adopt $(read_list "$PACKAGES/cask.txt")
}

try "brew cleanup" brew cleanup --prune=all

# Key remap for non-US Mac keyboards; on a US keyboard it breaks \ (see macos/README.md)
if [ "$KEYREMAP" = 1 ]; then
  info "Installing key remap"
  run mkdir -p "$HOME/Library/LaunchAgents"
  run cp "$DOTFILES/macos/com.local.KeyRemapping.plist" "$HOME/Library/LaunchAgents/"
  did "install $HOME/Library/LaunchAgents/com.local.KeyRemapping.plist (active from next login)"
fi

report_failures
