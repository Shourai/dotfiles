#!/usr/bin/env bash
# Make zsh the login shell, point it at ~/.config/zsh and install its plugins.
# Also moves files left in the repo by the old layout (history, plugin clones).
# Safe to rerun; plugins are updated when they are already there.
#
#   setup/zsh.sh [--dry-run]

set -euo pipefail
source "$(dirname "$0")/lib.sh"
parse_flags "$@"

PLUGINS="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
STATE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
BREW_ZSH=/home/linuxbrew/.linuxbrew/bin/zsh
user="$(id -un)"

info "Setting up zsh"

# Which zsh is the login shell: macOS's own, Homebrew's on Ubuntu (newest; apt's zsh
# stays installed as fallback), pacman's on Arch
if is_macos; then
  zsh_path=/bin/zsh
elif is_ubuntu && [ -x "$BREW_ZSH" ]; then
  zsh_path="$BREW_ZSH"
else
  zsh_path="$(command -v zsh || true)"
fi

# ZDOTDIR in the system-wide zshenv, so $HOME needs no .zshenv.
# Which file depends on how zsh was built: macOS and Homebrew's zsh read /etc/zshenv,
# zsh from pacman or apt reads /etc/zsh/zshenv.
set_zdotdir() {
  local file="$1"
  if grep -qs '^export ZDOTDIR=' "$file"; then
    ok "ZDOTDIR already set in $file"
  else
    run sudo mkdir -p "$(dirname "$file")"
    # shellcheck disable=SC2016  # $HOME must stay literal in the file
    append_root "$file" 'export ZDOTDIR="$HOME/.config/zsh"'
    did "set ZDOTDIR in $file"
  fi
}
if is_macos || [ "$zsh_path" = "$BREW_ZSH" ]; then
  set_zdotdir /etc/zshenv
fi
if is_linux; then
  set_zdotdir /etc/zsh/zshenv   # pacman/apt zsh (on Ubuntu the fallback shell)
fi

# Login shell
if is_macos; then
  current="$(dscl . -read "/Users/$user" UserShell 2>/dev/null | awk '{print $2}')"
else
  current="$(getent passwd "$user" | cut -d: -f7)"
fi
if [ -z "$zsh_path" ]; then
  warn "zsh is not installed, skipping login shell"
elif [ "$current" = "$zsh_path" ]; then
  ok "login shell is already $zsh_path"
elif ! "$zsh_path" -c 'exit 0' 2>/dev/null; then
  warn "$zsh_path doesn't start; not making it the login shell"
else
  # chsh only accepts shells listed in /etc/shells
  grep -qx "$zsh_path" /etc/shells || append_root /etc/shells "$zsh_path"
  run sudo chsh -s "$zsh_path" "$user"
  did "set login shell to $zsh_path"
fi

# One-time move from the old layout, where zsh wrote its history and cache into the repo
# folder and plugins were cloned there too
old="$DOTFILES/zsh"
if [ -f "$old/history" ]; then
  if [ -e "$STATE/history" ]; then
    warn "two zsh histories: $old/history and $STATE/history; merge them by hand"
  else
    run mkdir -p "$STATE"
    run mv "$old/history" "$STATE/history"
    did "move zsh history to $STATE/history"
  fi
fi
for leftover in "$old/.zcompdump" "$old/pure" "$old/zsh-ssh"; do
  if [ -e "$leftover" ]; then
    run rm -rf "$leftover"
    did "remove old $leftover"
  fi
done

# Plugins (sourced from zshrc)
run mkdir -p "$PLUGINS"
clone_or_pull https://github.com/sindresorhus/pure.git "$PLUGINS/pure"
clone_or_pull https://github.com/sunlei/zsh-ssh.git    "$PLUGINS/zsh-ssh"

report_failures
