HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.


########## Syntax highlighting package from brew ##########

# ------------------------------------------------------------------------------
# - Syntax highlighting package from brew                                      -
# ------------------------------------------------------------------------------
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ------------------------------------------------------------------------------
# - Aliases                                                                    -
# ------------------------------------------------------------------------------

# Colorize output, add file type indicator, and put sizes in human readable format
alias ls='ls -GFh'
alias ll='ls -GFhl'
alias la='ls -GFha'
alias ..='cd ../'
alias /='cd /'
alias ~='cd ~'
alias python=python3
alias pip=pip3
alias cp='cp -iv'
alias mkdir='mkdir -pv'
alias emd='emacs --daemon'


# ------------------------------------------------------------------------------
# - General Configurations                                                     -
# ------------------------------------------------------------------------------
# If non-ambiguous, allow changing into a directory just by typing its name
# (ie, make "cd" optional)
setopt autocd

# Detect and prompt to correct typos in commands.
# Note there is a "correctall" variant which also prompts to correct arguments
# to commands, but this ends up being more troublesome than useful.
setopt correct

# Disables the beep zsh would otherwise make when giving invalid input (such as
# hitting backspace on an command line).
setopt nobeep


# ------------------------------------------------------------------------------
# - Run emacs in the background                                                -
# ------------------------------------------------------------------------------
# emacs() { command emacs "$@" & }
ec() { command emacsclient -n -c "$@" & }

# ------------------------------------------------------------------------------
# - Autocompletion settings                                                    -
# ------------------------------------------------------------------------------

# Use completion functionality
autoload -Uz compinit 
compinit

# If the <tab> key is pressed with multiple possible options, print the
# options.  If the options are printed, begin cycling through them.
zstyle ':completion:*' menu select

# Case insensitive completion 
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Print the categories the completion options fit into.
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Use colors when outputting file names for completion options.
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# Do not prompt to cd into current directory.
# For example, cd ../<tab> should not prompt current directory.
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# ------------------------------------------------------------------------------
# - Visual settings                                                            -
# ------------------------------------------------------------------------------

PROMPT='%~ ❯ '

# ------------------------------------------------------------------------------
# - Vi mode in ZSH                                                             -
# ------------------------------------------------------------------------------
bindkey -v

# Minimize escape sequence detection delay
export KEYTIMEOUT=1

## Prompt when in insert or normal mode
function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    zle reset-prompt
}

zle -N zle-keymap-select
zle -N zle-line-init

# ------------------------------------------------------------------------------
# - insert_mode_(key bindings)                                                 -
# ------------------------------------------------------------------------------

# Have i_backspace work as it does in Vim.
bindkey -M viins "^?" backward-delete-char

# Have i_ctrl-a work as it does in Vim.
bindkey -M viins "^A" beginning-of-line

# Have i_ctrl-p work as c_ctrl-p does in Vim.
bindkey -M viins "^P" up-line-or-history

# Have i_ctrl-e work as it does in Vim.
bindkey -M viins "^E" end-of-line

# Have i_ctrl-n work as c_ctrl-n does in Vim.
bindkey -M viins "^N" down-line-or-history

# Have i_ctrl-h work as it does in Vim.
bindkey -M viins "^H" backward-delete-char

# Have i_ctrl-b work as i_ctrl-p does in Vim.
bindkey -M viins "^B" _history-complete-newer

# Have i_ctrl-f work as i_ctrl-n does in Vim.
bindkey -M viins "^F" _history-complete-older

# Prepend "sudo ".  This does not have a Vim parallel.
bindkey "^S" prepend-sudo

# Prepend "vim ".  This does not have a Vim parallel.
bindkey "^V" prepend-vim

# Have i_ctrl-u work as it does in Vim.
bindkey -M viins "^U" backward-kill-line

# Have i_ctrl-w work as it does in Vim.
bindkey -M viins "^W" backward-kill-word

# Have i_ctrl-x_i_ctrl-l work as it does in Vim.
bindkey -M viins "^X^L" history-beginning-search-backward-then-append

# Display _completion_help for creating completion functions.  This does not
# have a Vim parallel.
bindkey -M viins "^X^H" _complete_help

# attempt to complete line based on history, roughly as i_ctrl-x_ctrl-l does in
# Vim.
bindkey -M viins "^X^L" history-incremental-search-backward

# Cut the contents of the line and paste immediately when the next prompt
# appears.  This does not have a clean Vim parallel.
bindkey -M viins "^Y" push-line


# ------------------------------------------------------------------------------
# - normal_mode_(key_bindings)                                                 -
# ------------------------------------------------------------------------------

# Have ctrl-a work as it does in Vim.
bindkey -M vicmd "^A" increment-number

# Mimics Vim's "ca" text object functionality.
bindkey -M vicmd "ca" change-around

# Mimics Vim's "ci" text object functionality.
bindkey -M vicmd "ci" change-in

# If not explicitly set, above ca/ci bindings will cause a delay
bindkey -M vicmd "cc" vi-change-whole-line

# Mimic Vim's da text-object functionality.
bindkey -M vicmd "da" delete-around

# Mimic Vim's di text-object functionality.
bindkey -M vicmd "di" delete-in
#
# If not explicitly set, above da/di bindings will cause a delay
bindkey -M vicmd "dd" kill-whole-line

# Have ctrl-e work as it does in Vim.
bindkey -M vicmd "^E" vi-add-eol

# Have g~ work as it does in Vim.
bindkey -M vicmd "g~" vi-oper-swap-case

# Have ga work as it does in Vim.
bindkey -M vicmd "ga" what-cursor-position

# Have gg work as it does in Vim.
bindkey -M vicmd "gg" beginning-of-history

# Have G work as it does in Vim.
bindkey -M vicmd "G" end-of-history

# Have ctrl-r work as it does in Vim.
bindkey -M vicmd "^R" redo

# Editing the line in Vim proper.
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd "^V" edit-command-line
bindkey -M vicmd v edit-command-line

# Have ctrl-a work as it does in Vim.
bindkey -M vicmd "^X" decrement-number


# ------------------------------------------------------------------------------
# - fasd                                                                       -
# ------------------------------------------------------------------------------
# initialize fasd
eval "$(fasd --init auto)"   

# custom fasd aliases
alias e='f -e "emacsclient -n -c"' # quick opening files with emacs
alias p='f -e python3' # quick opening files with python3

# ------------------------------------------------------------------------------
# - Enable Enhancd                                                             -
# ------------------------------------------------------------------------------
[ -f ~/Documents/enhancd/init.sh ] && source ~/Documents/enhancd/init.sh

# ------------------------------------------------------------------------------
# - Fuzzy completion for zsh by junegunn                                       -
# ------------------------------------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ------------------------------------------------------------------------------
# - Enable autojump                                                            -
# ------------------------------------------------------------------------------
# Using fasd now instead of autojump
# [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh


# ==============================================================================
# = functions_and_zle_widgets                                                  =
# ==============================================================================
#
# ------------------------------------------------------------------------------
# - zle_widgets                                                                -
# ------------------------------------------------------------------------------
#
# The ZLE widges are all followed by "zle -<MODE> <NAME>" and bound below in
# the "Key Bindings" section.

# Prepend "sudo" to the command line if it is not already there.
prepend-sudo() {
	if ! echo "$BUFFER" | grep -q "^sudo "
	then
		BUFFER="sudo $BUFFER"
		CURSOR+=5
	fi
}
zle -N prepend-sudo

# Prepend "vim" to the command line if it is not already there.
prepend-vim() {
	if ! echo "$BUFFER" | grep -q "^vim "
	then
		BUFFER="vim $BUFFER"
		CURSOR+=5
	fi
}
zle -N prepend-vim

# Delete all characters between a pair of characters.  Mimics Vim's "di" text
# object functionality.
delete-in() {
	# Create locally-scoped variables we'll need
	local CHAR LCHAR RCHAR LSEARCH RSEARCH COUNT
	# Read the character to indicate which text object we're deleting.
	read -k CHAR
	if [ "$CHAR" = "w" ]
	then # diw, delete the word.
		# find the beginning of the word under the cursor
		zle vi-backward-word
		# set the left side of the delete region at this point
		LSEARCH=$CURSOR
		# find the end of the word under the cursor
		zle vi-forward-word
		# set the right side of the delete region at this point
		RSEARCH=$CURSOR
		# Set the BUFFER to everything except the word we are removing.
		RBUFFER="$BUFFER[$RSEARCH+1,${#BUFFER}]"
		LBUFFER="$LBUFFER[1,$LSEARCH]"
		return
	# diw was unique.  For everything else, we just have to define the
	# characters to the left and right of the cursor to be removed
	elif [ "$CHAR" = "(" ] || [ "$CHAR" = ")" ] || [ "$CHAR" = "b" ]
	then # di), delete inside of a pair of parenthesis
		LCHAR="("
		RCHAR=")"
	elif [ "$CHAR" = "[" ] || [ "$CHAR" = "]" ]
	then # di], delete inside of a pair of square brackets
		LCHAR="["
		RCHAR="]"
	elif [ $CHAR = "{" ] || [ $CHAR = "}" ] || [ "$CHAR" = "B" ]
	then # di], delete inside of a pair of braces
		LCHAR="{"
		RCHAR="}"
	else
		# The character entered does not have a special definition.
		# Simply find the first instance to the left and right of the
		# cursor.
		LCHAR="$CHAR"
		RCHAR="$CHAR"
	fi
	# Find the first instance of LCHAR to the left of the cursor and the
	# first instance of RCHAR to the right of the cursor, and remove
	# everything in between.
	# Begin the search for the left-sided character directly the left of the cursor.
	LSEARCH=${#LBUFFER}
	# Keep going left until we find the character or hit the beginning of the buffer.
	while [ "$LSEARCH" -gt 0 ] && [ "$LBUFFER[$LSEARCH]" != "$LCHAR" ]
	do
		LSEARCH=$(expr $LSEARCH - 1)
	done
	# If we hit the beginning of the command line without finding the character, abort.
	if [ "$LBUFFER[$LSEARCH]" != "$LCHAR" ]
	then
		return
	fi
	# start the search directly to the right of the cursor
	RSEARCH=0
	# Keep going right until we find the character or hit the end of the buffer.
	while [ "$RSEARCH" -lt $(expr ${#RBUFFER} + 1 ) ] && [ "$RBUFFER[$RSEARCH]" != "$RCHAR" ]
	do
		RSEARCH=$(expr $RSEARCH + 1)
	done
	# If we hit the end of the command line without finding the character, abort.
	if [ "$RBUFFER[$RSEARCH]" != "$RCHAR" ]
	then
		return
	fi
	# Set the BUFFER to everything except the text we are removing.
	RBUFFER="$RBUFFER[$RSEARCH,${#RBUFFER}]"
	LBUFFER="$LBUFFER[1,$LSEARCH]"
}
zle -N delete-in


# Delete all characters between a pair of characters and then go to insert mode.
# Mimics Vim's "ci" text object functionality.
change-in() {
	zle delete-in
	zle vi-insert
}
zle -N change-in

# Delete all characters between a pair of characters as well as the surrounding
# characters themselves.  Mimics Vim's "da" text object functionality.
delete-around() {
	zle delete-in
	zle vi-backward-char
	zle vi-delete-char
	zle vi-delete-char
}
zle -N delete-around

# Delete all characters between a pair of characters as well as the surrounding
# characters themselves and then go into insert mode  Mimics Vim's "ca" text
# object functionality.
change-around() {
	zle delete-in
	zle vi-backward-char
	zle vi-delete-char
	zle vi-delete-char
	zle vi-insert
}
zle -N change-around

# Increment the number under the cursor, or find the next number to the right
# of the cursor and increment that number.  Emulate vim's ctrl-a functionality.
# This code is not my style at all; presumably I found it somewhere online, but
# I no longer remember the source to cite or credit.
increment-number() {
	emulate -L zsh
	setopt extendedglob
	local pos num newnum sign buf
	if [[ $BUFFER[$((CURSOR + 1))] = [0-9] ]]; then
		pos=$((${#LBUFFER%%[0-9]##} + 1))
	else
		pos=$(($CURSOR + ${#RBUFFER%%[0-9]*} + 1))
	fi
	(($pos <= ${#BUFFER})) || return
	num=${${BUFFER[$pos,-1]}%%[^0-9]*}
	if ((pos > 0)) && [[ $BUFFER[$((pos - 1))] = '-' ]]; then
		num=$((0 - num))
		((pos--))
	fi
	newnum=$((num + ${NUMERIC:-${incarg:-1}}))
	if ((pos > 1)); then
		buf=${BUFFER[0,$((pos - 1))]}${BUFFER[$pos,-1]/$num/$newnum}
	else
		buf=${BUFFER/$num/$newnum}
	fi
	BUFFER=$buf
	CURSOR=$((pos + $#newnum - 2))
}
zle -N increment-number

# Decrement the number under the cursor, or find the next number to the right
# of the cursor and increment that number.  Emulate vim's ctrl-x functionality.
# This code is not my style at all; presumably I found it somewhere online, but
# I no longer remember the source to cite or credit.
decrement-number() {
	emulate -L zsh
	setopt extendedglob
	local pos num newnum sign buf
	if [[ $BUFFER[$((CURSOR + 1))] = [0-9] ]]; then
		pos=$((${#LBUFFER%%[0-9]##} + 1))
	else
		pos=$(($CURSOR + ${#RBUFFER%%[0-9]*} + 1))
	fi
	(($pos <= ${#BUFFER})) || return
	num=${${BUFFER[$pos,-1]}%%[^0-9]*}
	if ((pos > 0)) && [[ $BUFFER[$((pos - 1))] = '-' ]]; then
		num=$((0 - num))
		((pos--))
	fi
	newnum=$((num - ${NUMERIC:-${incarg:-1}}))
	if ((pos > 1)); then
		buf=${BUFFER[0,$((pos - 1))]}${BUFFER[$pos,-1]/$num/$newnum}
	else
		buf=${BUFFER/$num/$newnum}
	fi
	BUFFER=$buf
	CURSOR=$((pos + $#newnum - 2))
}
zle -N decrement-number