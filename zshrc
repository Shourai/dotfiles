# ------------------------------------------------------------------------------
# - Path Config                                                                -
# ------------------------------------------------------------------------------
export PATH="/opt/homebrew/bin:/opt/homebrew/opt/gnu-sed/libexec/gnubin:$HOME/.local/bin:$HOME/go/bin/:$PATH"

# ------------------------------------------------------------------------------
# - Aliases                                                                    -
# ------------------------------------------------------------------------------

# Colorize output, add file type indicator, and put sizes in human readable format
if [[ "$(uname)" = "Darwin" ]]; then
    alias ls='gls -Fh --color=always'
    alias ll='gls -Fhl --color=always'
    alias la='gls -Fha --color=always'
else
    alias ls='ls -v -Fh --color=always'
    alias ll='ls -v -Fhl --color=always'
    alias la='ls -v -Fha --color=always'
    alias open='xdg-open'
fi

alias ..='cd ../'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cd..='cd ../'
alias /='cd /'
alias ~='cd ~'
alias cp='cp -iv'
alias mkdir='mkdir -pv'
alias vi='\vim'
alias vim='nvim'
alias zshrc='vim ~/.zshrc'
alias tx='tmuxinator'

## Git related
alias g='git'
alias lg='lazygit'

# ------------------------------------------------------------------------------
# - General Configurations                                                     -
# ------------------------------------------------------------------------------
# If non-ambiguous, allow changing into a directory just by typing its name
# (ie, make "cd" optional)
setopt autocd

# Detect and prompt to correct typos in commands.
# Note there is a "correctall" variant which also prompts to correct arguments
# to commands, but this ends up being more troublesome than useful.
# setopt correct
# setopt correctall

# Disables the beep zsh would otherwise make when giving invalid input (such as
# hitting backspace on an command line).
setopt no_beep

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt append_history         # Allow multiple terminal sessions to all append to one zsh command history
setopt extended_history       # save timestamp of command and duration
setopt inc_append_history     # Add comamnds as they are typed, do not wait until shell exit
setopt hist_expire_dups_first # when trimming history, lose oldest duplicates first
setopt hist_ignore_dups       # Do not write events to history that are duplicates of previous events
setopt hist_ignore_space      # remove command line from history list when first character on the line is a space
setopt hist_find_no_dups      # When searching history do not display results already cycled through twice
setopt hist_reduce_blanks     # Remove extra blanks from each command line being added to history
setopt hist_verify            # do not execute, just expand history
setopt share_history          # imports new commands and appends typed commands to history
setopt hist_ignore_all_dups   # Delete old recorded entry if new entry is a duplicate.
setopt hist_save_no_dups      # Do not write duplicate entries in the history file.

# Set editor
if [[ "$(uname)" = "Darwin" ]]; then
    export EDITOR=/usr/local/bin/nvim
elif [ -f /etc/arch-release ]; then
    export EDITOR=/usr/bin/nvim
fi

# ------------------------------------------------------------------------------
# - Custom functions                                                           -
# ------------------------------------------------------------------------------
mkcd() { mkdir -p "$@" && cd "$@"; }      # Create a directory and cd to it afterwards
emc() { command emacsclient -n -c -a '' "$@" & } # use `emc <file>` to open file in emacsclient, start daemon if not running
# emacs() { command emacs "$@" & }

# ------------------------------------------------------------------------------
# - Autocompletion settings                                                    -
# ------------------------------------------------------------------------------

# Use completion functionality
autoload -Uz compinit && compinit

setopt always_to_end # When completing from the middle of a word, move the cursor to the end of the word
setopt auto_menu # show completion menu on successive tab press. needs unsetop menu_complete to work
setopt auto_name_dirs # any parameter that is set to the absolute name of a directory immediately becomes a name for that directory
setopt complete_in_word # Allow completion from within a word/phrase
setopt auto_list # automatically list choices on ambiguous completion

unsetopt menu_complete # do not autoselect the first completion entry

# ------------------------------------------------------------------------------
# - Visual settings                                                            -
# ------------------------------------------------------------------------------

fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
zstyle :prompt:pure:path color 147
zstyle :prompt:pure:prompt:success color blue
prompt pure

# ------------------------------------------------------------------------------
# - Vi mode in ZSH                                                             -
# ------------------------------------------------------------------------------
bindkey -v

# Minimize escape sequence detection delay
export KEYTIMEOUT=1

# Save previous RPROMPT to restore when vim status not displayed
RPROMPT_PREVIOUS=$RPROMPT

# Default color settings
if [ -z "$VIMTO_COLOR_NORMAL_TEXT" ]; then VIMTO_COLOR_NORMAL_TEXT=black; fi
if [ -z "$VIMTO_COLOR_NORMAL_BACKGROUND" ]; then VIMTO_COLOR_NORMAL_BACKGROUND=white; fi

function zle-keymap-select zle-line-init {
	# Command mode
	if [ $KEYMAP = vicmd ]; then
		RPROMPT_PREVIOUS=$RPROMPT
		RPROMPT=$'%K{$VIMTO_COLOR_NORMAL_BACKGROUND} %F{$VIMTO_COLOR_NORMAL_TEXT}NORMAL%f %k'
	# Insert mode
	else
		RPROMPT=$RPROMPT_PREVIOUS
	fi
	zle reset-prompt
}

# Need to initially clear RPROMPT for it to work on first prompt
export RPROMPT=$RPROMPT_PREVIOUS

# Change appearance
zle -N zle-line-init # When a new line starts
zle -N zle-keymap-select  # When vi mode changes

# ------------------------------------------------------------------------------
# - insert_mode_(key bindings)                                                 -
# ------------------------------------------------------------------------------

bindkey -M viins '^a'    beginning-of-line
bindkey -M viins '^e'    end-of-line
bindkey -M viins '^k'    kill-line
# bindkey -M viins "^t"    transpose-words
# bindkey -M viins '^r'    history-incremental-pattern-search-backward
# bindkey -M viins '^s'    history-incremental-pattern-search-forward
bindkey -M viins '^p'    up-line-or-history
bindkey -M viins '^n'    down-line-or-history
bindkey -M viins '^y'    yank
bindkey -M viins '^b'    backward-char
bindkey -M viins '^f'    forward-char
bindkey -M viins '^w'    backward-kill-word
bindkey -M viins '^u'    backward-kill-line
bindkey -M viins '^h'    backward-delete-char
bindkey -M viins '^?'    backward-delete-char
bindkey -M viins '^_'    undo
bindkey -M viins '^x^r'  redisplay
bindkey -M viins '\eOH'  beginning-of-line                 # Home
bindkey -M viins '\eOF'  end-of-line                       # End
bindkey -M viins '\e[2~' overwrite-mode                    # Insert
bindkey -M viins '\ef'   forward-word                      # Alt-f
bindkey -M viins '\eb'   backward-word                     # Alt-b
bindkey -M viins '\ed'   kill-word                         # Alt-d
bindkey -M viins '\e^h'  backward-kill-word                # Alt-backspace
bindkey -M viins '\e^?'  backward-kill-word                # Alt-backspace
bindkey -M viins '\e.'   insert-last-word

# Display _completion_help for creating completion functions.  This does not
# have a Vim parallel.
bindkey -M viins "^X^H" _complete_help

# attempt to complete line based on history, roughly as i_ctrl-x_ctrl-l does in
# Vim.
bindkey -M viins "^X^L" history-incremental-search-backward

# ------------------------------------------------------------------------------
# - normal_mode_(key_bindings)                                                 -
# ------------------------------------------------------------------------------

# Editing the line in Vim proper.
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd "^V" edit-command-line
bindkey '^x^e' edit-command-line
bindkey '^xe' edit-command-line

# Have ctrl-a work as it does in Vim.
bindkey -M vicmd "^X" decrement-number


# ------------------------------------------------------------------------------
# - Fuzzy completion for zsh by junegunn                                       -
# ------------------------------------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.fzf/shell/key-bindings.zsh ] && source ~/.fzf/shell/key-bindings.zsh

[ -f /usr/share/fzf/completion.zsh ] && source /usr/share/fzf/completion.zsh
[ -f /usr/share/fzf/key-bindings.zsh ] && source /usr/share/fzf/key-bindings.zsh

if [ -x "$(command -v fd)" ]
then
    export FZF_DEFAULT_COMMAND='fd --type f'
    export FZF_CTRL_T_COMMAND="fd --type f"
    export FZF_ALT_C_COMMAND="fd --type d"
fi

export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
export FZF_CTRL_T_OPTS=" --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# ==============================================================================
# = z.lua settings
# ==============================================================================
eval "$(lua ~/Documents/github/z.lua/z.lua --init zsh enhanced once echo)"

# ==============================================================================
# = NNN settings
# ==============================================================================

export NNN_PLUG='p:preview-tabbed;d:dragdrop'
export NNN_FIFO='/tmp/nnn.fifo'

# ==============================================================================
# = zsh ssh settings
# ==============================================================================
source ~/.zsh/zsh-ssh/zsh-ssh.zsh

# ------------------------------------------------------------------------------
# - Syntax highlighting package                                                -
# ------------------------------------------------------------------------------

if [[ "$(uname)" = "Darwin" ]]; then
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /etc/arch-release ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ------------------------------------------------------------------------------
# - Autosuggestion package
# ------------------------------------------------------------------------------

if [[ "$(uname)" = "Darwin" ]]; then
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#808080'
elif [ -f /etc/arch-release ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#808080'
fi

# Disable software flow control where ctrl+s freezes the terminal
stty -ixon
