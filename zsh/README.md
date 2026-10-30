# zsh

Linked to `~/.config/zsh` by `setup/link.sh`. `setup/zsh.sh` sets `ZDOTDIR="$HOME/.config/zsh"`
in the system-wide zshenv, so zsh reads its config from here and `$HOME` needs no zsh files.

The config files start with a dot, so use `ll` (or `ls -a`) to see them.

| File        | Loaded by                          | Contains                                                  |
|-------------|------------------------------------|-----------------------------------------------------------|
| `.zshenv`   | every zsh, scripts included        | platform flags (`IS_DARWIN`, `IS_ARCH`), XDG dirs, editor, SSH agent |
| `.zprofile` | login shells, after `.zshenv`      | starts Hyprland on TTY1 (Arch)                            |
| `.zshrc`    | interactive shells, after the above | options, history, PATH, completion, prompt, fzf, zoxide, plugins |
| `aliases`   | sourced from `.zshrc`              | aliases                                                   |

Keep `.zshenv` small and quiet: it also runs for every zsh script.

## Where things live

| What                       | Where                                   |
|----------------------------|-----------------------------------------|
| History                    | `~/.local/state/zsh/history`            |
| Completion cache           | `~/.cache/zsh/zcompdump`                |
| pure prompt, zsh-ssh       | `~/.local/share/zsh/plugins/` (cloned and updated by `setup/zsh.sh`) |
| autosuggestions, syntax highlighting | package manager (`packages/common.txt`) |

## Shortcuts

| Command      | What it does                                   |
|--------------|------------------------------------------------|
| `zshrc`      | edit `.zshrc`                                  |
| `gf`         | fuzzy-pick a git-tracked file and open it      |
| `gb`         | fuzzy-pick a branch and check it out           |
| `ghist`      | fuzzy-pick a commit and show it                |
| `pkg-clean`  | Arch: fuzzy-pick installed packages to remove  |
| `Ctrl-T` / `Alt-C` / `Ctrl-R` | fzf: file, directory, history |
