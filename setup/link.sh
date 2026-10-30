#!/usr/bin/env bash
# Symlink the configs in this repo into ~/.config (and a few other places),
# then install the yazi packages those configs need.
# Safe to rerun; run it again after adding a new config below.
#
#   setup/link.sh [--dry-run]

set -euo pipefail
source "$(dirname "$0")/lib.sh"
parse_flags "$@"

info "Linking dotfiles"

# Shared
link "$DOTFILES/zsh"                "$HOME/.config/zsh"
link "$DOTFILES/git"                "$HOME/.config/git"
link "$DOTFILES/yazi"               "$HOME/.config/yazi"
link "$DOTFILES/ghostty"            "$HOME/.config/ghostty"
link "$DOTFILES/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"  # file only: other lazygit files stay out of the repo
link "$DOTFILES/tmux/tmux.conf"     "$HOME/.config/tmux/tmux.conf"      # file only: tpm puts plugins next to it
link "$NVIM_CONFIG"                 "$HOME/.config/nvim"                # separate repo

# Arch Linux
if is_arch; then
  link "$DOTFILES/arch/wayland/hypr"     "$HOME/.config/hypr"
  link "$DOTFILES/arch/wayland/waybar"   "$HOME/.config/waybar"
  link "$DOTFILES/ghostty/linux.ghostty" "$DOTFILES/ghostty/os.ghostty"  # per-OS ghostty settings
fi

# macOS
if is_macos; then
  link "$DOTFILES/macos/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
  link "$DOTFILES/ghostty/macos.ghostty" "$DOTFILES/ghostty/os.ghostty"  # per-OS ghostty settings
fi

# Clean up links to configs that were removed from the repo
prune_links "$HOME/.config"
prune_links "$HOME/.local/share"

# yazi flavors and plugins listed in yazi/package.toml (not stored in the repo)
if has ya; then
  info "Installing yazi packages"
  run ya pkg install
fi
