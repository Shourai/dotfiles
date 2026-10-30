#!/usr/bin/env bash
# Make zsh the login shell, point it at ~/.config/zsh and install its plugins.
# Safe to rerun; plugins are updated when they are already there.
#
#   setup/zsh.sh [--dry-run]

set -euo pipefail
source "$(dirname "$0")/lib.sh"
parse_flags "$@"

PLUGINS="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"

info "Setting up zsh"

# ZDOTDIR in the system-wide zshenv, so $HOME needs no .zshenv
if is_macos; then
  zshenv=/etc/zshenv
else
  zshenv=/etc/zsh/zshenv
fi
if grep -qs 'ZDOTDIR' "$zshenv"; then
  ok "ZDOTDIR already set in $zshenv"
else
  run sudo sh -c "echo 'export ZDOTDIR=\"\$HOME/.config/zsh\"' >> $zshenv"
  ok "set ZDOTDIR in $zshenv"
fi

# Login shell (macOS already defaults to zsh)
zsh_path="$(command -v zsh || true)"
if [ -z "$zsh_path" ]; then
  warn "zsh is not installed, skipping login shell"
elif [ "$(basename "${SHELL:-}")" = "zsh" ]; then
  ok "login shell is already zsh"
else
  run sudo chsh -s "$zsh_path" "$USER"
  ok "login shell set to $zsh_path"
fi

# Plugins (sourced from zshrc)
run mkdir -p "$PLUGINS"
clone_or_pull https://github.com/sindresorhus/pure.git "$PLUGINS/pure"
clone_or_pull https://github.com/sunlei/zsh-ssh.git    "$PLUGINS/zsh-ssh"
