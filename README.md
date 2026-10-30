# dotfiles

Configuration for Arch Linux and macOS. One command takes a clean install to a working setup,
and running it again brings an existing machine up to date.

## Install

On a fresh machine (Arch: install with `archinstall` first):

```sh
curl -fsSL https://raw.githubusercontent.com/Shourai/dotfiles/main/install | bash
```

With flags:

```sh
curl -fsSL https://raw.githubusercontent.com/Shourai/dotfiles/main/install | bash -s -- --extras
```

On a machine that already has the repo:

```sh
~/Documents/github/dotfiles/install [--extras] [--defaults] [--dry-run]
```

| Flag         | What it does                                                    |
|--------------|-----------------------------------------------------------------|
| `--extras`   | Also install the optional packages in `packages/extras-*.txt`   |
| `--defaults` | Also apply the macOS system settings in `macos/defaults.sh`     |
| `--dry-run`  | Print what would change without changing anything               |

The repo must live at `~/Documents/github/dotfiles`; the scripts and some configs assume that path.

## What `install` does

1. Installs git (Homebrew first on macOS).
2. Clones this repo and [nvim](https://github.com/Shourai/nvim) to `~/Documents/github/` and
   switches their remotes to SSH.
3. Runs the scripts in `setup/`, in this order:

| Script            | What it does                                                                  |
|-------------------|-------------------------------------------------------------------------------|
| `setup/arch.sh`   | Arch: `pacman -Syu`, installs yay, then the pacman and AUR package lists      |
| `setup/macos.sh`  | macOS: Homebrew formulae and casks, the key remap, `--defaults`               |
| `setup/link.sh`   | Symlinks the configs into `~/.config`, installs yazi packages (`ya pkg`)      |
| `setup/zsh.sh`    | Sets `ZDOTDIR` in `/etc/zshenv`, makes zsh the login shell, clones plugins    |

Every script can also be run on its own and is safe to rerun. Shared helpers are in `setup/lib.sh`.

## Common tasks

**Add a package**: add a line to the right list in `packages/`, then run `setup/arch.sh` or `setup/macos.sh`.

| List                | Installed with                                 |
|---------------------|------------------------------------------------|
| `common.txt`        | pacman and Homebrew (same name on both)        |
| `pacman.txt`        | pacman (Arch only)                             |
| `aur.txt`           | yay (Arch only)                                |
| `brew.txt`          | `brew install` (macOS only)                    |
| `cask.txt`          | `brew install --cask` (macOS only)             |
| `extras-*.txt`      | the same managers, only with `--extras`        |

**Add a config**: put it in the repo, add a `link` line to `setup/link.sh`, then run `setup/link.sh`.
If something already exists at the target, it is moved to `<name>.bak-<date>` first.
Links to configs that were removed from the repo are cleaned up automatically.

## Theme

One Dark everywhere, using the palette of nvim's `onedark.nvim` (`dark` style).

| Tool              | Where it's set                                                             |
|-------------------|----------------------------------------------------------------------------|
| ghostty           | `theme = One Half Dark` in `ghostty/config.ghostty` (same background and accents) |
| yazi, lazygit, fzf, eza, pure prompt | no theme of their own: they use the terminal's colours  |
| bat               | `BAT_THEME="OneHalfDark"` in `zsh/.zshrc`                                  |
| tmux              | `od_*` colours in `tmux/tmux.conf`                                         |
| waybar            | `@define-color` lines in `arch/wayland/waybar/style.css`                   |
| Hyprland borders  | `col` in `arch/wayland/hypr/hyprland.lua`                                  |
| nvim              | `onedark.nvim` in the separate nvim repo                                   |

## Layout

```
dotfiles
 ├─ install          bootstrap script (see above)
 ├─ setup/           arch.sh, macos.sh, link.sh, zsh.sh, lib.sh
 ├─ packages/        package lists per package manager
 ├─ zsh/             -> ~/.config/zsh (dotted files, see zsh/README.md)
 ├─ tmux/tmux.conf   -> ~/.config/tmux/tmux.conf (tpm installs itself on first start)
 ├─ git/             -> ~/.config/git (see git/README.md)
 ├─ lazygit/config.yml -> ~/.config/lazygit/config.yml
 ├─ yazi/            -> ~/.config/yazi (see yazi/README.md)
 ├─ ghostty/         -> ~/.config/ghostty (config.ghostty + linux/macos.ghostty via os.ghostty)
 ├─ arch/            Arch only: Hyprland, hypridle, hyprlock, hyprpaper, waybar, post-install notes
 └─ macos/           macOS only: AeroSpace, key remap, defaults.sh, notes
```

## Useful CLI tools

- bat
- btop
- erdtree
- eza
- fd
- fzf
- gping
- jq
- jless
- lazygit
- mtr
- netop
- pandoc
- ripgrep
- sshs
- termshark
- tmux
- yazi
- zoxide
