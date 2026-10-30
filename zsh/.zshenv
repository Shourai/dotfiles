# ----------------------------------------
# - Platform detection                   -
# ----------------------------------------

if [[ "$OSTYPE" == darwin* ]]; then
  export IS_DARWIN=1
elif [[ -f /etc/arch-release ]]; then
  export IS_ARCH=1
fi

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

# SSH agent: the first running one of Bitwarden, 1Password (macOS), 1Password (Linux).
# Skipped inside an SSH session so a forwarded agent keeps working.
if [[ -z "$SSH_CONNECTION" ]]; then
  for sock in \
    "$HOME/.bitwarden-ssh-agent.sock" \
    "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" \
    "$HOME/.1password/agent.sock"
  do
    if [[ -S "$sock" ]]; then
      export SSH_AUTH_SOCK="$sock"
      break
    fi
  done
  unset sock
fi
