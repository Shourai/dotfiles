#!/usr/bin/env bash
# Install macOS packages from packages/*.txt with Homebrew, plus the key remap.
# Safe to rerun; already installed packages are skipped.
#
#   setup/macos.sh [--extras] [--defaults] [--dry-run]

set -euo pipefail
source "$(dirname "$0")/lib.sh"
parse_flags "$@"

is_macos || die "this script is for macOS"

# Homebrew (normally already installed by `install`)
if ! has brew; then
  info "Installing Homebrew"
  run env NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

info "Updating Homebrew"
run brew analytics off
run brew update
run brew upgrade

lists_brew="$PACKAGES/common.txt $PACKAGES/brew.txt"
lists_cask="$PACKAGES/cask.txt"
if [ "$EXTRAS" = 1 ]; then
  lists_brew="$lists_brew $PACKAGES/extras-brew.txt"
  lists_cask="$lists_cask $PACKAGES/extras-cask.txt"
fi

# shellcheck disable=SC2046,SC2086  # word splitting is intended: one package per word
{
  info "Installing formulae"
  run brew install $(read_list $lists_brew)

  info "Installing casks"
  run brew install --cask $(read_list $lists_cask)
}

run brew cleanup --prune=all

# Key remap for non-US keyboards, applied by launchd at login (see macos/README.md)
info "Installing key remap"
run mkdir -p "$HOME/Library/LaunchAgents"
run cp "$DOTFILES/macos/com.local.KeyRemapping.plist" "$HOME/Library/LaunchAgents/"
ok "$HOME/Library/LaunchAgents/com.local.KeyRemapping.plist"

if [ "$DEFAULTS" = 1 ]; then
  info "Applying macOS defaults"
  run bash "$DOTFILES/macos/defaults.sh"
fi
