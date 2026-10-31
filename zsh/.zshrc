# Interactive shells only. Order matters: PATH before anything that looks up tools,
# compinit before fzf and zsh-ssh, syntax highlighting last.

# --- HISTORY ---

# Not exported: other shells started from zsh (e.g. bash) would write into it
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=12000    # events in memory; above SAVEHIST so HIST_EXPIRE_DUPS_FIRST has room
SAVEHIST=10000    # events in the history file

# State dir for the history, cache dir for the completion dump
[[ -d "$XDG_STATE_HOME/zsh" && -d "$XDG_CACHE_HOME/zsh" ]] ||
  command mkdir -p "$XDG_STATE_HOME/zsh" "$XDG_CACHE_HOME/zsh"

setopt EXTENDED_HISTORY        # save start time and duration
setopt SHARE_HISTORY           # share history between running shells
setopt HIST_EXPIRE_DUPS_FIRST  # trim duplicates first
setopt HIST_IGNORE_ALL_DUPS    # a repeated command replaces its older copy
setopt HIST_FIND_NO_DUPS       # skip duplicates when searching
setopt HIST_IGNORE_SPACE       # don't record commands that start with a space
setopt HIST_REDUCE_BLANKS      # strip extra blanks
setopt HIST_VERIFY             # show !-expansions before running them

# --- TERMINAL INTEGRATION ---

# ghostty's shell integration (cursor, title, prompt marks, ssh-terminfo/ssh-env). ghostty
# can't load it itself because the system zshenv sets ZDOTDIR. Not inside tmux, where its
# ssh wrapper would report ghostty instead of tmux as the terminal.
if [[ -n "$GHOSTTY_RESOURCES_DIR" && -z "$TMUX" &&
      -r "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration" ]]; then
  source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi

# --- OPTIONS ---

setopt AUTO_CD             # type a directory name to cd into it
setopt AUTO_PUSHD          # cd pushes the old directory onto the stack
setopt PUSHD_IGNORE_DUPS   # no duplicates in the stack
setopt PUSHD_SILENT        # don't print the stack after pushd/popd
setopt CORRECT             # offer to fix mistyped commands
setopt CDABLE_VARS         # cd into a path stored in a variable
setopt EXTENDED_GLOB       # extended globbing (also needed for the (#q) test below)
setopt NO_BEEP             # no beep on ZLE errors

# --- PATH ---

# No duplicates (nested shells inside tmux inherit PATH)
typeset -U path PATH

# Homebrew: Apple Silicon, Intel Mac, Linux (Ubuntu). Also adds its completions to fpath.
for brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  [[ -x "$brew" ]] && { eval "$("$brew" shellenv)"; break; }
done
unset brew

# User scripts first
path=("$HOME/.local/bin" $path)

# Plugins cloned by setup/zsh.sh
ZSH_PLUGINS="$XDG_DATA_HOME/zsh/plugins"

# --- ALIASES ---

source "$ZDOTDIR/aliases"

# --- KEYBINDINGS ---

# Emacs keymap. Needed explicitly: zsh picks vi mode when VISUAL contains "vi" (nvim).
bindkey -e

# Home, End, Delete: the emacs keymap has no bindings for them, so they typed "~".
# Sequences sent by ghostty (normal and application mode), tmux and the Linux console.
for key widget in '^[[H' beginning-of-line '^[OH' beginning-of-line '^[[1~' beginning-of-line \
                  '^[[F' end-of-line       '^[OF' end-of-line       '^[[4~' end-of-line \
                  '^[[3~' delete-char; do
  bindkey "$key" "$widget"
done
unset key widget

# --- COMPLETION ---

# LS_COLORS for eza and completion lists. Skipped when inherited (tmux panes, nested shells),
# which saves a fork. gdircolors is GNU's on macOS (coreutils).
if [[ -z "$LS_COLORS" ]]; then
  if (( $+commands[gdircolors] )); then
    eval "$(gdircolors -b)"
  elif (( $+commands[dircolors] )); then
    eval "$(dircolors -b)"
  fi
fi

# Fast compinit: full check at most once a day, otherwise trust the cache. A full compinit
# doesn't rewrite an unchanged dump, so touch it, or the daily check would run every time.
autoload -Uz compinit
zcompdump="$XDG_CACHE_HOME/zsh/zcompdump"
if [[ -n $zcompdump(#qN.mh-24) ]]; then
  compinit -C -d "$zcompdump"
else
  compinit -d "$zcompdump" && touch "$zcompdump"
fi
unset zcompdump

# Menu selection and coloured lists
zmodload zsh/complist

setopt COMPLETE_IN_WORD    # complete from both ends of a word

# Arrow-key selection menu
zstyle ':completion:*' menu select
# Exact, then case-insensitive, then partial-word, then substring matches
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Completion scripts, then retry with ignored matches
zstyle ':completion:*' completer _complete _ignored
# File colours match LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# --- PROMPT ---

# pure, cloned by setup/zsh.sh (plain prompt until it is)
if [[ -d "$ZSH_PLUGINS/pure" ]]; then
  fpath+=("$ZSH_PLUGINS/pure")
  autoload -Uz promptinit && promptinit
  zstyle :prompt:pure:path color 147
  zstyle :prompt:pure:prompt:success color blue
  prompt pure
fi

# --- FZF ---

if (( $+commands[fzf] )); then
  # Key bindings (Ctrl-T, Alt-C, Ctrl-R) and ** completion
  source <(fzf --zsh)

  # fd lists files faster than find, includes hidden files, skips .git
  if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type d --strip-cwd-prefix --hidden --follow --exclude .git"
  fi

  # Compact layout
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border=none --info=inline"

  # Previews: eza tree for directories, bat for files; Ctrl-/ cycles the preview window
  _fzf_preview_cmd='if [ -d {} ]; then eza --tree --level=3 --color=always --icons=always {}; else bat --style=numbers --color=always --line-range :500 {}; fi'
  export FZF_ALT_C_OPTS="--preview 'eza --tree --level=3 --color=always --icons=always {}'"
  export FZF_CTRL_T_OPTS="--preview '$_fzf_preview_cmd' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
  unset _fzf_preview_cmd

  # gf: fuzzy-pick a git-tracked file and open it
  gf() { local file; file=$(git ls-files | fzf --prompt "Git Files> ") && [[ -n "$file" ]] && ${EDITOR:-nvim} "$file"; }
  # gb: fuzzy-pick a branch and check it out (remotes/origin/x becomes x)
  gb() { local branch; branch=$(git branch -a --color=always | grep -v "/HEAD" | fzf --ansi --prompt "Branches> ") && branch=${${branch##* }#remotes/origin/} && [[ -n "$branch" ]] && git checkout "$branch"; }
  # ghist: fuzzy-pick a commit and show it
  ghist() { local commit; commit=$(git log --oneline --color=always | fzf --ansi --prompt "History> ") && commit=${commit%% *} && [[ -n "$commit" ]] && git show "$commit"; }
fi

# --- ZOXIDE ---

# z/zi: jump to frequent directories
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

# --- BAT ---

export BAT_THEME="OneHalfDark"  # matches ghostty

# --- PLUGINS ---

# SSH host completion from ~/.ssh/config, cloned by setup/zsh.sh. After fzf: it wraps the Tab
# binding it finds.
[[ -r "$ZSH_PLUGINS/zsh-ssh/zsh-ssh.zsh" ]] && source "$ZSH_PLUGINS/zsh-ssh/zsh-ssh.zsh"

# Autosuggestions, then syntax highlighting (must be sourced last), from the package manager:
# Homebrew's share dir (macOS, Ubuntu), else Arch's. Each file is checked on its own.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#808080'
_plugin_dirs=(${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share} ${IS_ARCH:+/usr/share/zsh/plugins})
for _plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  _plugin_file=( $^_plugin_dirs/$_plugin/$_plugin.zsh(N-.) )
  (( $#_plugin_file )) && source "$_plugin_file[1]"
done
unset _plugin _plugin_dirs _plugin_file
