# zsh

Linked to `~/.config/zsh` by `setup/link.sh`. `setup/zsh.sh` sets `ZDOTDIR` to it in the system
zshenv (`/etc/zsh/zshenv`; `/etc/zshenv` on macOS and for Homebrew's zsh), so `$HOME` has no zsh
files. The files start with a dot: list them with `ll`.

| File        | Loaded by                           | Contains                                                  |
|-------------|-------------------------------------|-----------------------------------------------------------|
| `.zshenv`   | every zsh, scripts included         | `IS_ARCH` flag, XDG dirs, editor, SSH agent socket        |
| `.zprofile` | login shells, after `.zshenv`       | starts Hyprland when logging in on TTY1 (Arch)            |
| `.zshrc`    | interactive shells, after the above | history, ghostty integration, options, PATH (Homebrew), completion, prompt, fzf, Atuin, zoxide, plugins |
| `aliases`   | sourced from `.zshrc`               | aliases                                                   |

Keep `.zshenv` small and silent: it runs for every zsh script too.

| What                       | Where                                                   |
|----------------------------|---------------------------------------------------------|
| Native zsh history         | `~/.local/state/zsh/history`                            |
| Atuin history database     | `~/.atuin/data/history.db` on new installs; `atuin info` shows the active path |
| Completion cache           | `~/.cache/zsh/zcompdump` (full check once a day)        |
| pure prompt, zsh-ssh, fzf-tab | `~/.local/share/zsh/plugins/`, cloned and updated by `setup/zsh.sh` |
| autosuggestions, syntax highlighting | the package manager (`packages/common.txt`)   |

## SSH agent

`.zshenv` picks the first that's there:

1. Bitwarden's socket (the macOS app, or the Snap on Ubuntu), while Bitwarden runs with its agent
   on (Settings, "Enable SSH agent");
2. 1Password's, once 1Password is installed (even before it has started);
3. whatever the session set: GNOME's agent on Ubuntu, launchd's on macOS.

It isn't changed inside an SSH session, so a forwarded agent keeps working. Check with
`echo $SSH_AUTH_SOCK; ssh-add -l`.

## Behaviour worth knowing

- **ghostty integration** is sourced in `.zshrc`, because the `ZDOTDIR` setting stops ghostty from
  loading it; not inside tmux. It gives the cursor shape, window title and the SSH terminfo
  handling set in `ghostty/config.ghostty`.
- **PATH**: `~/.local/bin`, then Homebrew (if installed), then the system. Nested shells reuse
  Homebrew's exported environment instead of running `brew shellenv` again; its completion path
  is restored before `compinit`.
- **Missing tools** (fzf, zoxide, eza, bat, nvim, the plugins) are skipped without errors; the
  aliases fall back to `ls`, `cat` and `vi`, and `gf`/`gb`/`ghist` need fzf.

## History search and sync

Native zsh history keeps 10,000 entries on disk, shares them across shells on the same machine,
records times and durations, and trims duplicates. fzf already gives it fuzzy search. Atuin adds
filters for directory, session and host, plus optional cross-machine sync. It keeps a separate
history database; Up, `fc` and autosuggestions still use native zsh history.

`install` gets Atuin from pacman on Arch or Homebrew on macOS and Ubuntu. If the rest of the
setup is already in place, install just `atuin` (`sudo pacman -S --needed atuin` or
`brew install atuin`) and open a new terminal. `Ctrl-R` searches Atuin; press `Ctrl-R` again in
the picker to cycle filters. Enter puts the result on the command line for review. If Atuin
is missing or its init command fails, `Ctrl-R` stays with fzf (or zsh if fzf is absent).

- **Import is optional.** Review your old history for secrets first, then run
  `HISTFILE="$HISTFILE" atuin import zsh` once from zsh. The temporary assignment is needed
  because this setup does not export `HISTFILE`. The original file is not changed by the import.
- **Sync is optional.** For a new Atuin Cloud account, run `atuin register`. Save the encryption
  key from `atuin key` in your password manager, then run `atuin sync`. On the next machine, run
  `atuin login` to sign in to the same account, provide the key when prompted, and run `atuin sync`.
  See [Atuin's sync guide](https://docs.atuin.sh/latest/guide/sync/) for self-hosting. Don't run
  Atuin's shell setup; these dotfiles already handle that.
- **Privacy.** Sync is end-to-end encrypted; the local history database is not. Both zsh and Atuin
  skip commands starting with a space, but Atuin's secret detection is not a guarantee. Avoid
  typing credentials into commands, and never commit the database, key or session files.

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
| `pkg-clean`               | Arch: fuzzy-pick explicitly installed packages and remove them with their unused dependencies |
| `wgup`, `wgdown`          | `wg-quick up/down` (needs wireguard-tools, not installed by setup) |
| `Ctrl-T` / `Alt-C`         | fzf: file / directory                                 |
| `Ctrl-R`                  | Atuin history search (fzf or zsh fallback)             |
| `Tab`                     | completion menu in fzf (fzf-tab); `<` / `>` switch group |
| `Home`, `End`, `Delete`  | start and end of line, delete character               |
| `Ctrl-X`, then `Ctrl-E` | edit the current command in `$EDITOR`; save and exit to return to the shell |
