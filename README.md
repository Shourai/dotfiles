# dotfiles

Configuration for Arch Linux, Ubuntu and macOS. One command takes a clean install to a working setup,
and running it again brings an existing machine up to date.

## Install

On a fresh machine (Arch: install with `archinstall` first; Ubuntu: 26.04 LTS with GNOME):

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

1. Installs git (Homebrew first on macOS, apt on Ubuntu).
2. Clones this repo and [nvim](https://github.com/Shourai/nvim) to `~/Documents/github/` and
   switches their remotes to SSH.
3. Runs the scripts in `setup/`, in this order:

| Script            | What it does                                                                  |
|-------------------|-------------------------------------------------------------------------------|
| `setup/arch.sh`   | Arch: `pacman -Syu`, installs yay, then the pacman and AUR package lists      |
| `setup/macos.sh`  | macOS: Homebrew formulae and casks, the key remap, `--defaults`               |
| `setup/ubuntu.sh` | Ubuntu: base system from apt, Homebrew, CLI tools from Homebrew               |
| `setup/link.sh`   | Symlinks the configs into `~/.config`, installs yazi packages (`ya pkg`)      |
| `setup/zsh.sh`    | Sets `ZDOTDIR` in the system zshenv, makes zsh the login shell, clones plugins |

Every script can also be run on its own and is safe to rerun. Shared helpers are in `setup/lib.sh`.

## Common tasks

**Add a package**: add a line to the right list in `packages/`, then run `setup/arch.sh`, `setup/ubuntu.sh` or `setup/macos.sh`.

| List                | Installed with                                 |
|---------------------|------------------------------------------------|
| `common.txt`        | pacman (Arch) and Homebrew (macOS, Ubuntu): same name on both |
| `pacman.txt`        | pacman (Arch only)                             |
| `aur.txt`           | yay (Arch only)                                |
| `brew.txt`          | Homebrew on macOS and Ubuntu                   |
| `brew-macos.txt`    | Homebrew on macOS only                         |
| `cask.txt`          | `brew install --cask` (macOS only)             |
| `apt.txt`           | apt (Ubuntu only): base system, ghostty, fonts |
| `extras-*.txt`      | the same managers, only with `--extras`        |

**Add a config**: put it in the repo, add a `link` line to `setup/link.sh`, then run `setup/link.sh`.
If something already exists at the target, it is moved to `<name>.bak-<date>` first.
Links to configs that were removed from the repo are cleaned up automatically.

## Ubuntu

Same tools and versions as on macOS: apt provides only the base system, and Homebrew
(`/home/linuxbrew/.linuxbrew`) provides every CLI tool from `common.txt` and `brew.txt`.
Update them with `brew upgrade`, the system with `sudo apt upgrade`.

- **Login shell** is Homebrew's zsh. If Homebrew ever breaks and you can't log in, boot into
  recovery mode (root shell) and run `chsh -s /usr/bin/zsh <user>`; apt's zsh stays installed
  as the fallback.
- **Terminal**: ghostty comes from apt (Homebrew only has it for macOS). Ubuntu's own terminal,
  Ptyxis, stays installed as a fallback. To open ghostty with Ctrl+Alt+T, change that shortcut
  in GNOME Settings (Keyboard, custom shortcut with the command `ghostty`).
- **Desktop** stays GNOME; the Hyprland and waybar configs in `arch/` are Arch only.
- **Fonts**: none extra. ghostty uses Ubuntu Sans Mono (`ghostty/ubuntu.ghostty`) and its
  built-in Nerd Font icons for yazi, eza, nvim and tmux.

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
 ├─ ghostty/         -> ~/.config/ghostty (config.ghostty + arch/ubuntu/macos.ghostty via os.ghostty)
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
