#!/usr/bin/env bash
# Symlink the configs in this repo into ~/.config, pick the per-OS ghostty settings,
# then install the yazi packages those configs need.
# Safe to rerun; run it again after adding a new config below. Anything in the way of a
# link is moved to <name>.bak-<date>, never deleted.
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

# Arch Linux: Hyprland desktop
if is_arch; then
  link "$DOTFILES/arch/wayland/hypr"     "$HOME/.config/hypr"
  link "$DOTFILES/arch/wayland/waybar"   "$HOME/.config/waybar"
  link "$DOTFILES/ghostty/arch.ghostty"  "$DOTFILES/ghostty/os.ghostty"  # per-OS ghostty settings
fi

# Ubuntu: GNOME desktop
if is_ubuntu; then
  link "$DOTFILES/ghostty/ubuntu.ghostty" "$DOTFILES/ghostty/os.ghostty"  # per-OS ghostty settings
fi

# macOS
if is_macos; then
  link "$DOTFILES/macos/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
  link "$DOTFILES/ghostty/macos.ghostty" "$DOTFILES/ghostty/os.ghostty"  # per-OS ghostty settings
fi

# Clean up links to configs that were removed from the repo (top level of ~/.config only)
prune_links "$HOME/.config"

# yazi flavors and plugins listed in yazi/package.toml (not stored in the repo)
if has ya; then
  info "Installing yazi packages"
  try "ya pkg install" ya pkg install
else
  warn "yazi's ya not found; run setup/link.sh again after installing packages"
fi

report_failures
