#!/usr/bin/env bash
# Symlink the configs in this repo into ~/.config (and a few other places).
# Safe to rerun; run it again after adding a new config below.
#
#   setup/link.sh [--dry-run]

set -euo pipefail
source "$(dirname "$0")/lib.sh"
parse_flags "$@"

info "Linking dotfiles"

# Shared
link "$DOTFILES/zsh"            "$HOME/.config/zsh"
link "$DOTFILES/git"            "$HOME/.config/git"
link "$DOTFILES/yazi"           "$HOME/.config/yazi"
link "$DOTFILES/ghostty"        "$HOME/.config/ghostty"
link "$DOTFILES/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"  # file only: tpm puts plugins next to it
link "$NVIM_CONFIG"             "$HOME/.config/nvim"            # separate repo

# Arch Linux
if is_arch; then
  link "$DOTFILES/arch/wayland/hypr"   "$HOME/.config/hypr"
  link "$DOTFILES/arch/wayland/waybar" "$HOME/.config/waybar"
  link "$DOTFILES/arch/fontconfig"     "$HOME/.config/fontconfig"
  link "$DOTFILES/arch/fonts"          "$HOME/.local/share/fonts"
fi

# macOS
if is_macos; then
  link "$DOTFILES/macos/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
fi

# Clean up links to configs that were removed from the repo
prune_links "$HOME/.config"
prune_links "$HOME/.local/share"
