#!/usr/bin/env bash
# Symlink the configs in this repo into ~/.config, pick the per-OS ghostty settings,
# then install the yazi packages those configs need and update the tmux plugins.
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
link "$DOTFILES/bat"                "$HOME/.config/bat"
link "$DOTFILES/ghostty"            "$HOME/.config/ghostty"
link "$DOTFILES/lazygit/config.yml" "$HOME/.config/lazygit/config.yml"  # file only: other lazygit files stay out of the repo
link "$DOTFILES/tmux/tmux.conf"     "$HOME/.config/tmux/tmux.conf"      # file only: tpm puts plugins next to it
link "$NVIM_CONFIG"                 "$HOME/.config/nvim"                # separate repo

# Linux: default fonts (macOS doesn't use fontconfig)
if is_linux; then
  link "$DOTFILES/fontconfig" "$HOME/.config/fontconfig"
fi

# Arch Linux: Hyprland desktop
if is_arch; then
  link "$DOTFILES/arch/hypr"             "$HOME/.config/hypr"
  link "$DOTFILES/arch/waybar"           "$HOME/.config/waybar"
  link "$DOTFILES/arch/fuzzel"           "$HOME/.config/fuzzel"
  link "$DOTFILES/ghostty/arch.ghostty"  "$DOTFILES/ghostty/os.ghostty"  # per-OS ghostty settings
fi

# Ubuntu: GNOME desktop
if is_ubuntu; then
  link "$DOTFILES/ghostty/ubuntu.ghostty" "$DOTFILES/ghostty/os.ghostty"  # per-OS ghostty settings
  # file only: other environment.d files stay out of the repo; takes effect at the next login
  link "$DOTFILES/ubuntu/environment.d/homebrew.conf" "$HOME/.config/environment.d/homebrew.conf"
fi

# macOS
if is_macos; then
  link "$DOTFILES/macos/aerospace.toml" "$HOME/.config/aerospace/aerospace.toml"
  link "$DOTFILES/ghostty/macos.ghostty" "$DOTFILES/ghostty/os.ghostty"  # per-OS ghostty settings
fi

# Clean up links to configs that were removed from the repo (top level of ~/.config only)
prune_links "$HOME/.config"

# bat and delta read themes from bat's cache, not from bat/themes directly
if has bat; then
  info "Building bat's theme cache"
  try "bat cache" bat cache --build
else
  warn "bat not found; run setup/link.sh again after installing packages"
fi

# yazi flavors and plugins listed in yazi/package.toml (not stored in the repo)
if has ya; then
  info "Installing yazi packages"
  try "ya pkg install" ya pkg install
else
  warn "yazi's ya not found; run setup/link.sh again after installing packages"
fi

# Install missing tmux plugins before updating; retry failures on the next setup run.
tpm="$HOME/.config/tmux/plugins/tpm"
if has tmux; then
  if [ ! -e "$tpm" ]; then
    info "Installing tmux plugin manager"
    try "tmux plugin manager" git clone https://github.com/tmux-plugins/tpm "$tpm"
  fi
  if [ -x "$tpm/bin/install_plugins" ] || [ "$DRY_RUN" = 1 ]; then
    # A running server may have started before tpm was installed.
    # shellcheck disable=SC2016 # HOME is expanded by tmux's shell.
    try "tmux plugin manager initialization" tmux start-server \; run-shell '"$HOME/.config/tmux/plugins/tpm/tpm"'
    info "Installing missing tmux plugins"
    try "tmux plugin installation" "$tpm/bin/install_plugins"
    info "Updating tmux plugins"
    try "tmux plugin updates" "$tpm/bin/update_plugins" all
    # shellcheck disable=SC2016 # HOME is expanded by tmux's shell.
    try "tmux plugin loading" tmux start-server \; run-shell '"$HOME/.config/tmux/plugins/tpm/tpm"'
  elif [ -e "$tpm" ]; then
    fail "tmux plugin manager is incomplete: $tpm"
  fi
else
  warn "tmux not found; run setup/link.sh again after installing it"
fi

report_failures
