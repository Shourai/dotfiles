#!/usr/bin/env bash
# Install Arch Linux packages from packages/*.txt (pacman + AUR via yay).
# Also upgrades the whole system (pacman -Syu) and clears the package cache.
# Safe to rerun; already installed packages are skipped.
#
#   setup/arch.sh [--extras] [--dry-run]

set -euo pipefail
source "$(dirname "$0")/lib.sh"
parse_flags "$@"

is_arch || die "this script is for Arch Linux"

info "Updating system"
try "pacman -Syu" sudo pacman -Syu --needed --noconfirm base-devel git

# AUR helper, built in a temp folder that's removed even if the build fails
if has yay; then
  ok "yay is installed"
else
  info "Installing yay"
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  # shellcheck disable=SC2016  # $1 is expanded by the inner sh
  try "build yay" sh -c 'git clone --quiet https://aur.archlinux.org/yay.git "$1/yay" && makepkg -sir --noconfirm --dir "$1/yay"' _ "$tmp"
fi

lists_pacman="$PACKAGES/common.txt $PACKAGES/pacman.txt"
lists_aur="$PACKAGES/aur.txt"
if [ "$EXTRAS" = 1 ]; then
  lists_pacman="$lists_pacman $PACKAGES/extras-pacman.txt"
  lists_aur="$lists_aur $PACKAGES/extras-aur.txt"
fi

# One call per list: pacman installs a list all-or-nothing, so a failure here means
# nothing from that list was installed; the message names the list
# shellcheck disable=SC2046,SC2086  # word splitting is intended: one package per word
{
  info "Installing pacman packages"
  try "pacman packages ($lists_pacman)" sudo pacman -S --needed --noconfirm $(read_list $lists_pacman)

  info "Installing AUR packages"
  try "AUR packages ($lists_aur)" yay -S --needed --noconfirm $(read_list $lists_aur)
}

info "Cleaning up pacman cache"
try "pacman cache cleanup" sudo pacman -Sc --noconfirm

report_failures
