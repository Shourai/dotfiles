# ----------------------------------------
# - Platform detection                   -
# ----------------------------------------

# Used by .zshrc and aliases (not exported: only needed inside zsh)
[[ -f /etc/arch-release ]] && IS_ARCH=1

# ----------------------------------------
# - Environmental variables              -
# ----------------------------------------

# Set XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"

# Set Editor
export EDITOR="nvim"
export VISUAL="nvim"

# less
export LESSHISTFILE=-

# eza
export EZA_COLORS='xx=37'

# SSH agent: Bitwarden if it's running (macOS app, or the Snap on Ubuntu), otherwise 1Password
# if it's installed, otherwise the system's agent (GNOME's on Ubuntu).
# Not inside SSH sessions, so a forwarded agent keeps working.
if [[ -z "$SSH_CONNECTION" ]]; then
  for sock in "$HOME/.bitwarden-ssh-agent.sock" "$HOME/snap/bitwarden/current/.bitwarden-ssh-agent.sock"; do
    [[ -S "$sock" ]] && { export SSH_AUTH_SOCK="$sock"; break; }
  done
  if [[ "$SSH_AUTH_SOCK" != *bitwarden* ]]; then
    if [[ "$OSTYPE" == darwin* ]]; then
      sock="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    else
      sock="$HOME/.1password/agent.sock"
    fi
    # 1Password's socket is used as soon as it's installed, even before it has started
    [[ -d "${sock:h}" ]] && export SSH_AUTH_SOCK="$sock"
  fi
  unset sock
fi
