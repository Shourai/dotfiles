# zsh

Linked to `~/.config/zsh` by `setup/link.sh`. `setup/zsh.sh` sets `ZDOTDIR="$HOME/.config/zsh"`
in the system-wide zshenv (`/etc/zsh/zshenv`, or `/etc/zshenv` on macOS and for Homebrew's zsh),
so zsh reads its config from here and `$HOME` needs no zsh files.

The config files start with a dot, so use `ll` (or `ls -a`) to see them.

| File        | Loaded by                           | Contains                                                  |
|-------------|-------------------------------------|-----------------------------------------------------------|
| `.zshenv`   | every zsh, scripts included         | `IS_ARCH` flag, XDG dirs, editor, SSH agent socket        |
| `.zprofile` | login shells, after `.zshenv`       | starts Hyprland when logging in on TTY1 (Arch)            |
| `.zshrc`    | interactive shells, after the above | history, ghostty integration, options, PATH (Homebrew), completion, prompt, fzf, zoxide, plugins |
| `aliases`   | sourced from `.zshrc`               | aliases                                                   |

Keep `.zshenv` small and quiet: it also runs for every zsh script.

## Where things live

| What                       | Where                                   |
|----------------------------|-----------------------------------------|
| History                    | `~/.local/state/zsh/history` (machines set up before this layout: `setup/zsh.sh` moves it there; if both exist it only warns, see Troubleshooting in the main README) |
| Completion cache           | `~/.cache/zsh/zcompdump` (full check once a day, otherwise cached) |
| pure prompt, zsh-ssh       | `~/.local/share/zsh/plugins/` (cloned and updated by `setup/zsh.sh`) |
| autosuggestions, syntax highlighting | package manager (`packages/common.txt`) |

## Behaviour worth knowing

- **SSH agent** (`.zshenv`): Bitwarden's socket if Bitwarden is running (any install: .deb,
  AppImage, Snap, Flatpak, Mac App Store), otherwise 1Password's if 1Password is installed (even
  before it has started). With neither, the system's agent is used: GNOME's on Ubuntu
  (`$XDG_RUNTIME_DIR/gcr/ssh`), launchd's on macOS. Never changed inside an SSH session, so a
  forwarded agent keeps working. Check which one is in use with `echo $SSH_AUTH_SOCK; ssh-add -l`.
- **ghostty integration** (`.zshrc`): loaded by hand because the system zshenv's `ZDOTDIR` stops
  ghostty from loading it; only outside tmux. It provides the cursor shape, window title and the
  SSH terminfo/env handling set in `ghostty/config.ghostty`.
- **Homebrew** is put on `PATH` when installed (`/opt/homebrew`, `/usr/local`, `/home/linuxbrew`).

## Aliases and functions

| Command                   | What it does                                          |
|---------------------------|-------------------------------------------------------|
| `ls`, `l`, `ll`, `lll`, `lt` | eza: plain, long, long with hidden and git status, with header, tree |
| `cat`                     | bat without paging                                    |
| `vi`, `vim`               | nvim                                                  |
| `zshrc`                   | edit `.zshrc`                                         |
| `g`, `lg`                 | git, lazygit                                          |
| `cp`, `mkdir`             | `cp -iv` (asks before overwriting), `mkdir -pv`       |
| `..`, `...`, `....`       | go up one, two, three folders                         |
| `gf`                      | fuzzy-pick a git-tracked file and open it             |
| `gb`                      | fuzzy-pick a branch and check it out                  |
| `ghist`                   | fuzzy-pick a commit and show it                       |
| `pkg-clean`               | Arch: fuzzy-pick installed packages to remove         |
| `wgup`, `wgdown`          | `wg-quick up/down` (needs wireguard-tools, not installed by setup) |
| `Ctrl-T` / `Alt-C` / `Ctrl-R` | fzf: file, directory, history                     |
