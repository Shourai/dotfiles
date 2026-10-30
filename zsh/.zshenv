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

# SSH agent: Bitwarden if it's running, otherwise 1Password if it's installed (its socket is
# used even before 1Password has started, so shells opened earlier work once it runs).
# With neither, the system's agent (e.g. GNOME's on Ubuntu) is left alone.
# Skipped inside an SSH session so a forwarded agent keeps working.
if [[ -z "$SSH_CONNECTION" ]]; then
  if [[ "$OSTYPE" == darwin* ]]; then
    onepassword="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t"
  else
    onepassword="$HOME/.1password"
  fi
  if [[ -S "$HOME/.bitwarden-ssh-agent.sock" ]]; then
    export SSH_AUTH_SOCK="$HOME/.bitwarden-ssh-agent.sock"
  elif [[ -d "$onepassword" ]]; then
    export SSH_AUTH_SOCK="$onepassword/agent.sock"
  fi
  unset onepassword
fi
