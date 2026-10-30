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

# Which zsh to use as login shell: Homebrew's on Ubuntu (newest), the system one
# elsewhere (macOS ships /bin/zsh, Arch /usr/bin/zsh)
BREW_PREFIX=/home/linuxbrew/.linuxbrew
if is_ubuntu && [ -x "$BREW_PREFIX/bin/zsh" ]; then
  zsh_path="$BREW_PREFIX/bin/zsh"
else
  zsh_path="$(command -v zsh || true)"
fi

# ZDOTDIR in the system-wide zshenv, so $HOME needs no .zshenv.
# Which file depends on how zsh was built: macOS and Homebrew's zsh read /etc/zshenv,
# zsh from pacman or apt reads /etc/zsh/zshenv.
set_zdotdir() {
  local file="$1"
  if grep -qs 'ZDOTDIR' "$file"; then
    ok "ZDOTDIR already set in $file"
  else
    run sudo sh -c "mkdir -p '$(dirname "$file")' && echo 'export ZDOTDIR=\"\$HOME/.config/zsh\"' >> '$file'"
    ok "set ZDOTDIR in $file"
  fi
}
if is_macos; then
  set_zdotdir /etc/zshenv
else
  set_zdotdir /etc/zsh/zshenv
  if [ "$zsh_path" = "$BREW_PREFIX/bin/zsh" ]; then
    set_zdotdir /etc/zshenv
  fi
fi

# Login shell
if [ -z "$zsh_path" ]; then
  warn "zsh is not installed, skipping login shell"
elif is_macos && [ "$(basename "${SHELL:-}")" = "zsh" ]; then
  ok "login shell is already zsh"   # macOS default
elif [ "$(getent passwd "$USER" | cut -d: -f7)" = "$zsh_path" ]; then
  ok "login shell is already $zsh_path"
else
  # chsh only accepts shells listed in /etc/shells
  grep -qx "$zsh_path" /etc/shells || run sudo sh -c "echo '$zsh_path' >> /etc/shells"
  run sudo chsh -s "$zsh_path" "$USER"
  ok "login shell set to $zsh_path"
fi

# Plugins (sourced from zshrc)
run mkdir -p "$PLUGINS"
clone_or_pull https://github.com/sindresorhus/pure.git "$PLUGINS/pure"
clone_or_pull https://github.com/sunlei/zsh-ssh.git    "$PLUGINS/zsh-ssh"
