# ----------------------------------------
# - Environmental variables              -
# ----------------------------------------

# zsh
[[ -d "$XDG_STATE_HOME/zsh" ]] || command mkdir -p "$XDG_STATE_HOME/zsh"
export HISTFILE="$XDG_STATE_HOME/zsh/history"  # History filepath
export HISTSIZE=10000                          # Maximum events for internal history
export SAVEHIST=10000                          # Maximum events in history file

# ----------------------------------------
# - Navigation                           -
# ----------------------------------------

setopt AUTO_CD              # Go to folder path without using cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt CORRECT              # Spelling correction
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
setopt NO_BEEP              # Do not beep on error in ZLE.

# ----------------------------------------
# - History                              -
# ----------------------------------------

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks from each command line being added to the history list.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

# ----------------------------------------
# - Path settings                        -
# ----------------------------------------

# Keep PATH free of duplicates (e.g. in nested shells inside tmux)
typeset -U path PATH

# Add homebrew to path (Apple Silicon, then Intel)
if [[ -n "$IS_DARWIN" ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# Add .local/bin to path
path=("$HOME/.local/bin" $path)

# Plugins cloned by setup/zsh.sh
ZSH_PLUGINS="$XDG_DATA_HOME/zsh/plugins"

# ----------------------------------------
# - Aliases                              -
# ----------------------------------------

source $ZDOTDIR/aliases

# ----------------------------------------
# - Keymap                               -
# ----------------------------------------

# Set emacs keymap
bindkey -e

# ----------------------------------------
# - Completion                           -
# ----------------------------------------

# Initialize LS_COLORS
if command -v gdircolors &>/dev/null; then
  eval "$(gdircolors -b)"
elif command -v dircolors &>/dev/null; then
  eval "$(dircolors -b)"
fi

# Fast compinit: full check at most once a day, otherwise trust the cache
autoload -Uz compinit
[[ -d "$XDG_CACHE_HOME/zsh" ]] || command mkdir -p "$XDG_CACHE_HOME/zsh"
zcompdump="$XDG_CACHE_HOME/zsh/zcompdump"
if [[ -n $zcompdump(#qN.mh-24) ]]; then
  compinit -C -d "$zcompdump"
else
  compinit -d "$zcompdump"
fi
unset zcompdump

# Load the completion list module for colors
zmodload zsh/complist

setopt COMPLETE_IN_WORD     # Complete from both ends of a word.

# UI: Enable the arrow-key selection menu
zstyle ':completion:*' menu select

# LOGIC: Case-insensitive (all), partial-word, and then substring completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# LOGIC: Use the completion scripts, then retry with ignored matches
zstyle ':completion:*' completer _complete _ignored

# Colors for files and directory (match LS_COLORS)
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# ----------------------------------------
# - Visual settings                      -
# ----------------------------------------

fpath+=("$ZSH_PLUGINS/pure")
autoload -U promptinit; promptinit
zstyle :prompt:pure:path color 147
zstyle :prompt:pure:prompt:success color blue
prompt pure

# ----------------------------------------
# - FZF settings                         -
# ----------------------------------------

source <(fzf --zsh)

if [ -x "$(command -v fd)" ]; then
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d --strip-cwd-prefix --hidden --follow --exclude .git"
fi

# Minimalist UI & Layout
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=none --info=inline"

# Dynamic Preview (Eza for directories, Bat for files)
_fzf_preview_cmd='if [ -d {} ]; then eza --tree --level=3 --color=always --icons=always {}; else bat --style=numbers --color=always --line-range :500 {}; fi'

export FZF_ALT_C_OPTS="--preview 'eza --tree --level=3 --color=always --icons=always {}'"
export FZF_CTRL_T_OPTS="--preview '$_fzf_preview_cmd' --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Git Helpers
gf() { local file; file=$(git ls-files | fzf --prompt "Git Files> ") && [ -n "$file" ] && ${EDITOR:-nvim} "$file" }
gb() { local branch; branch=$(git branch -a --color=always | grep -v "/HEAD" | fzf --ansi --prompt "Branches> " | sed "s/.* //" | sed "s#remotes/origin/##") && [ -n "$branch" ] && git checkout "$branch" }
ghist() { local commit; commit=$(git log --oneline --color=always | fzf --ansi --prompt "History> " | awk '{print $1}') && [ -n "$commit" ] && git show "$commit" }

# ----------------------------------------
# - zoxide settings                      -
# ----------------------------------------

eval "$(zoxide init zsh)"

# ----------------------------------------
# - Bat settings                         -
# ----------------------------------------

export BAT_THEME="OneHalfDark"  # matches ghostty

# ----------------------------------------
# - Plugins                              -
# ----------------------------------------

# SSH settings
source "$ZSH_PLUGINS/zsh-ssh/zsh-ssh.zsh"

# Autosuggestions & syntax highlighting (installed by the package manager)
if [[ -n "$IS_DARWIN" ]]; then
  zsh_share="$HOMEBREW_PREFIX/share"
elif [[ -n "$IS_ARCH" ]]; then
  zsh_share="/usr/share/zsh/plugins"
fi

if [[ -n "$zsh_share" ]]; then
  source "$zsh_share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#808080'

  # Must be sourced last
  source "$zsh_share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
unset zsh_share
