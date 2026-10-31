# zsh

Linked to `~/.config/zsh` by `setup/link.sh`. `setup/zsh.sh` sets `ZDOTDIR` to it in the system
zshenv (`/etc/zsh/zshenv`; `/etc/zshenv` on macOS and for Homebrew's zsh), so `$HOME` has no zsh
files. The files start with a dot: list them with `ll`.

| File        | Loaded by                           | Contains                                                  |
|-------------|-------------------------------------|-----------------------------------------------------------|
| `.zshenv`   | every zsh, scripts included         | `IS_ARCH` flag, XDG dirs, editor, SSH agent socket        |
| `.zprofile` | login shells, after `.zshenv`       | starts Hyprland when logging in on TTY1 (Arch)            |
| `.zshrc`    | interactive shells, after the above | history, ghostty integration, options, PATH (Homebrew), completion, prompt, fzf, zoxide, plugins |
| `aliases`   | sourced from `.zshrc`               | aliases                                                   |

Keep `.zshenv` small and silent: it runs for every zsh script too.

| What                       | Where                                                   |
|----------------------------|---------------------------------------------------------|
| History                    | `~/.local/state/zsh/history`                            |
| Completion cache           | `~/.cache/zsh/zcompdump` (full check once a day)        |
| pure prompt, zsh-ssh       | `~/.local/share/zsh/plugins/`, cloned and updated by `setup/zsh.sh` |
| autosuggestions, syntax highlighting | the package manager (`packages/common.txt`)   |

## SSH agent

`.zshenv` picks the first that's there:

1. Bitwarden's socket (the macOS app, or the Snap on Ubuntu), while Bitwarden runs;
2. 1Password's, once 1Password is installed (even before it has started);
3. whatever the session set: GNOME's agent on Ubuntu, launchd's on macOS.

It isn't changed inside an SSH session, so a forwarded agent keeps working. Check with
`echo $SSH_AUTH_SOCK; ssh-add -l`.

## Behaviour worth knowing

- **ghostty integration** is sourced in `.zshrc`, because the `ZDOTDIR` setting stops ghostty from
  loading it; not inside tmux. It gives the cursor shape, window title and the SSH terminfo
  handling set in `ghostty/config.ghostty`.
- **PATH**: `~/.local/bin`, then Homebrew (if installed), then the system.
- **Missing tools** (fzf, zoxide, eza, bat, nvim, the plugins) are skipped without errors; the
  aliases fall back to `ls`, `cat` and `vi`, and `gf`/`gb`/`ghist` need fzf.

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
| `Home`, `End`, `Delete`  | start and end of line, delete character               |
