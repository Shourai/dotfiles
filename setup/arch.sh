#!/usr/bin/env bash
# Install Arch Linux packages from packages/*.txt (pacman + AUR via yay).
# Safe to rerun; already installed packages are skipped.
#
#   setup/arch.sh [--extras] [--dry-run]

set -euo pipefail
source "$(dirname "$0")/lib.sh"
parse_flags "$@"

is_arch || die "this script is for Arch Linux"

info "Updating system"
run sudo pacman -Syu --needed --noconfirm base-devel git

# AUR helper
if has yay; then
  ok "yay is installed"
else
  info "Installing yay"
  tmp="$(mktemp -d)"
  run git clone --quiet https://aur.archlinux.org/yay.git "$tmp/yay"
  run makepkg -si --noconfirm --dir "$tmp/yay"
  rm -rf "$tmp"
fi

lists_pacman="$PACKAGES/common.txt $PACKAGES/pacman.txt"
lists_aur="$PACKAGES/aur.txt"
if [ "$EXTRAS" = 1 ]; then
  lists_pacman="$lists_pacman $PACKAGES/extras-pacman.txt"
  lists_aur="$lists_aur $PACKAGES/extras-aur.txt"
fi

# shellcheck disable=SC2046,SC2086  # word splitting is intended: one package per word
{
  info "Installing pacman packages"
  run sudo pacman -S --needed --noconfirm $(read_list $lists_pacman)

  info "Installing AUR packages"
  run yay -S --needed --noconfirm $(read_list $lists_aur)
}

info "Cleaning up pacman cache"
run sudo pacman -Sc --noconfirm
