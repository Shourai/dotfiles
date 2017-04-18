HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.

autoload -Uz compinit 
compinit

########## Syntax highlighting package from brew ##########
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

########## Aliases ##########
# Colorize output, add file type indicator, and put sizes in human readable format
alias ls='ls -GFh'
alias ll='ls -GFhl'
alias la='ls -GFha'
alias ..='cd ..'
alias python=python3
alias pip=pip3

########## Run emacs in the background ##########
# emacs() { command emacs "$@" & }
ec() { command emacsclient -n -c "$@" & }

########## Autocompletion settings ##########

## Do menu-driven completion. ##
zstyle ':completion:*' menu select

## Case insensitive completion ##
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

########## Display the path working directory ##########
PROMPT='%~ ❯ '

########## Vi mode in zsh ##########
bindkey -v

bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word

## Prompt when in insert or normal mode
function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    zle reset-prompt
}

zle -N zle-keymap-select
zle -N zle-line-init

## enable changes inside brackets e.g. <di+)>, <ci+[>
autoload -U select-bracketed
autoload -U select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in visual viopp; do
    bindkey -M $km -- '-' vi-up-line-or-history
    for c in {a,i}${(s..)^:-\'\"\`\|,./:;-=+@}; do
        bindkey -M $km $c select-quoted
    done
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
        bindkey -M $km $c select-bracketed
    done
done

########## Eliminating delays on ESC in zsh ##########
export KEYTIMEOUT=1

########## Enable autojump ##########
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

########## Enable Enhancd  ##########
[ -f ~/Documents/enhancd/init.sh ] && source ~/Documents/enhancd/init.sh

########## Fuzzy completion for zsh by junegunn ##########
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
