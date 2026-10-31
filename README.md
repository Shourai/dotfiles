# dotfiles

Configuration for Arch Linux (Hyprland), Ubuntu 26.04 (GNOME) and macOS (AeroSpace).
One command takes a clean install to a working setup; running it again updates the repos,
the packages, the links and the zsh plugins.

The Neovim config is a separate repo, [nvim](https://github.com/Shourai/nvim), which `install`
clones next to this one. Its own README covers it.

## Prerequisites

- A normal user with `sudo` rights, an internet connection and `curl`
  (Ubuntu: `sudo apt install curl`; Arch and macOS have it).
- **Arch**: install with `archinstall` and pick no desktop profile and no display manager.
  Hyprland starts when you log in on TTY1 (see `zsh/.zprofile`); a login screen would bypass that.
- **Ubuntu**: 26.04 LTS or newer, standard desktop (GNOME).
- **macOS**: nothing extra; `install` installs Homebrew, which installs the Xcode command line tools.
- The repos must live at `~/Documents/github/dotfiles` and `~/Documents/github/nvim`; scripts and
  some configs (e.g. the wallpaper path in `arch/wayland/hypr/hyprpaper.conf`) assume these paths.
- To push changes, an SSH key for GitHub: `install` clones over https, then switches the remotes
  to SSH. The shell uses Bitwarden's or 1Password's SSH agent when one of them is there (see
  `zsh/README.md`). Setup installs 1Password only on macOS and on Arch with `--extras`, and
  Bitwarden nowhere: install the one you use yourself and enable its SSH agent.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/Shourai/dotfiles/main/install | bash
```

With flags:

```sh
curl -fsSL https://raw.githubusercontent.com/Shourai/dotfiles/main/install | bash -s -- --extras
```

| Flag         | What it does                                                                        |
|--------------|-------------------------------------------------------------------------------------|
| `--extras`   | Arch: also install `packages/extras-*.txt` (browsers, syncthing, 1Password, ...)    |
| `--defaults` | macOS: also apply the system settings in `macos/defaults.sh` (read it first)        |
| `--keyremap` | macOS: also install the key remap for non-US Mac keyboards (see `macos/README.md`)  |
| `--dry-run`  | Print what would change without changing anything (needs the repos cloned already)  |

`install --help` lists the same flags. Every script in `setup/` takes the flags it needs too.

### What `install` does

1. Installs git (Homebrew first on macOS, apt on Ubuntu, pacman on Arch).
2. Clones this repo and the nvim repo to `~/Documents/github/`, or fast-forwards them if they're
   already there (`git pull --ff-only`; local changes that conflict are left alone, with a warning).
3. Runs the script for this OS, then `setup/link.sh`, then `setup/zsh.sh`. If one fails, the others
   still run, and `install` lists what failed at the end. It's safe to rerun.

| Script            | What it does                                                                         |
|-------------------|--------------------------------------------------------------------------------------|
| `setup/arch.sh`   | `pacman -Syu`, installs yay, the pacman and AUR lists, clears the pacman cache        |
| `setup/ubuntu.sh` | `apt upgrade`, the apt list, Homebrew with the shared lists, `brew upgrade`, GNOME shortcuts |
| `setup/macos.sh`  | Homebrew formulae and casks, `brew upgrade`; key remap and `defaults.sh` with flags   |
| `setup/link.sh`   | Symlinks the configs into `~/.config`, picks the per-OS ghostty file, `ya pkg install` |
| `setup/zsh.sh`    | Sets `ZDOTDIR` in the system zshenv, makes zsh the login shell, clones the zsh plugins |

Shared helpers are in `setup/lib.sh`.

## Update

```sh
~/Documents/github/dotfiles/install
```

This pulls both repos and upgrades all packages (pacman/apt/Homebrew), relinks and updates the
zsh plugins. Plugins managed inside the tools themselves are updated there:

| What                 | How                                                     |
|----------------------|---------------------------------------------------------|
| Neovim plugins       | `:Lazy sync`, `:MasonUpdate`, `:TSUpdate` (see the nvim README) |
| tmux plugins         | `<prefix> U`                                            |
| yazi flavors/plugins | `ya pkg upgrade`                                        |

## Common tasks

**Add a package**: add a line to the right list in `packages/`, then run `install` (or just the
script for your OS). Note that this also upgrades everything else; to add only one package now,
install it by hand and add it to the list for next time.

| List              | Installed with                                                      |
|-------------------|---------------------------------------------------------------------|
| `common.txt`      | pacman on Arch and Homebrew on macOS/Ubuntu (same name on both)      |
| `pacman.txt`      | pacman (Arch)                                                       |
| `aur.txt`         | yay (Arch)                                                          |
| `brew.txt`        | Homebrew on macOS and Ubuntu                                        |
| `brew-macos.txt`  | Homebrew on macOS                                                   |
| `cask.txt`        | Homebrew casks (macOS apps and fonts)                               |
| `apt.txt`         | apt (Ubuntu): only the base system, ghostty and the Ubuntu font     |
| `extras-pacman.txt`, `extras-aur.txt` | Arch, only with `--extras`                      |

**Add a config**: put it in the repo, add a `link` line to `setup/link.sh`, run `setup/link.sh`.
Anything already at the target is moved to `<name>.bak-<date>`, never deleted.
Broken links directly in `~/.config` that point into this repo are removed by `setup/link.sh`;
links to single files in subfolders (e.g. `~/.config/tmux/tmux.conf`) must be removed by hand.

**Change keys or settings**: each folder's README lists its keys and where they're set:
[zsh](zsh/README.md), [tmux](tmux/README.md), [git](git/README.md), [yazi](yazi/README.md),
[Arch desktop](arch/README.md), [Ubuntu](ubuntu/README.md), [macOS](macos/README.md).

## Per machine

Things that are specific to one machine, and what to change on another:

| What                       | Where                                                                    |
|----------------------------|--------------------------------------------------------------------------|
| Monitors and workspace pinning (Arch) | MONITORS block in `arch/wayland/hypr/hyprland.lua`; `hyprctl monitors` lists the outputs |
| Workspace pinning (macOS)  | `[workspace-to-monitor-force-assignment]` in `macos/aerospace.toml`      |
| Work git identity          | create `~/.config/git/gitconfig_work` by hand (see `git/README.md`)      |
| Key remap (macOS)          | only with `--keyremap`, for non-US Mac keyboards                         |
| Optional packages (Arch)   | only with `--extras`; the browser keys in Hyprland need them             |

## Ubuntu

apt provides only the base system; Homebrew (`/home/linuxbrew/.linuxbrew`) provides every CLI tool
from `common.txt` and `brew.txt`, so the versions match macOS.

- **Login shell** is Homebrew's zsh. `setup/zsh.sh` only switches to it if it starts, and
  `setup/ubuntu.sh` switches back to apt's `/usr/bin/zsh` if a `brew upgrade` breaks it. A
  `brew upgrade` you run by hand isn't checked; if you then can't log in, see Troubleshooting.
- **Terminal**: ghostty comes from apt (Homebrew has it only for macOS); Ubuntu's own terminal,
  Ptyxis, stays as a fallback (open it from the app grid).
- **Shortcuts**: Ctrl+Alt+T and Super+Shift+Return open ghostty with tmux, Super+Return opens
  ghostty, as on Arch; everything else stays GNOME's default (see `ubuntu/README.md`).
- **Desktop** stays GNOME; the configs in `arch/` are Arch only.

## Troubleshooting

| Problem                                   | Fix                                                                    |
|-------------------------------------------|------------------------------------------------------------------------|
| `install` lists failed steps              | read the messages above the list, fix the cause, run `install` again    |
| A link replaced something you needed      | it's next to it as `<name>.bak-<date>`: remove the link, rename the backup back |
| Plain zsh prompt (no pure), no SSH host completion | the plugins aren't cloned yet: run `setup/zsh.sh`              |
| `setup/zsh.sh` warns about two zsh histories | a shell opened before the move still writes to `dotfiles/zsh/history`: run `exec zsh` in old shells, keep the history you want at `~/.local/state/zsh/history`, delete the other (it's gitignored) |
| zsh ignores the config (no prompt, aliases) | `ZDOTDIR` must be set in `/etc/zsh/zshenv` (Arch, apt's zsh) or `/etc/zshenv` (macOS, Homebrew's zsh): run `setup/zsh.sh` |
| Can't log in on Ubuntu after a `brew upgrade` | boot into recovery mode (root shell), run `chsh -s /usr/bin/zsh <user>` |
| Hyprland shows a red config error         | `hyprctl configerrors`; see `arch/README.md` for checking changes first |
| ghostty settings missing (font, Alt key)  | `ghostty/os.ghostty` is created by `setup/link.sh`; run it again        |
| Undo `--keyremap` or `--defaults` (macOS) | see `macos/README.md`                                                   |

To see what a script would do without changing anything, run it with `--dry-run`.

## Uninstall

1. Remove the links in `~/.config` that point into this repo, and rename any `<name>.bak-<date>`
   backups back.
2. Delete the `export ZDOTDIR=...` line from `/etc/zsh/zshenv` and, on macOS or with Homebrew's
   zsh, from `/etc/zshenv`.
3. Pick another login shell, e.g. `chsh -s /bin/bash`.
4. macOS: undo `--keyremap` / `--defaults` as described in `macos/README.md`.

Packages stay installed; remove them with your package manager if you want.

## Theme

One Dark everywhere, using the palette of nvim's `onedark.nvim` (`dark` style).

| Tool              | Where it's set                                                             |
|-------------------|----------------------------------------------------------------------------|
| ghostty           | `theme = One Half Dark` in `ghostty/config.ghostty` (same background and accents) |
| yazi, lazygit, fzf | no theme of their own: they use the terminal's colours                    |
| pure prompt, eza, autosuggestions | a few fixed colours in `zsh/.zshrc` / `zsh/.zshenv` (`147`, `xx=37`, `#808080`) |
| bat               | `BAT_THEME="OneHalfDark"` in `zsh/.zshrc`                                  |
| tmux              | `od_*` colours in `tmux/tmux.conf`                                         |
| waybar            | `@define-color` lines in `arch/wayland/waybar/style.css`                   |
| Hyprland borders  | `col` in `arch/wayland/hypr/hyprland.lua`                                  |
| hyprlock          | its own white/grey text colours in `arch/wayland/hypr/hyprlock.conf`       |
| nvim              | `onedark.nvim` in the nvim repo                                            |

## Layout

```
dotfiles
 ├─ install            bootstrap and update script (see above)
 ├─ setup/             arch.sh, ubuntu.sh, macos.sh, link.sh, zsh.sh, lib.sh
 ├─ packages/          package lists per package manager
 ├─ zsh/               -> ~/.config/zsh (see zsh/README.md)
 ├─ tmux/tmux.conf     -> ~/.config/tmux/tmux.conf (see tmux/README.md)
 ├─ git/               -> ~/.config/git (see git/README.md)
 ├─ lazygit/config.yml -> ~/.config/lazygit/config.yml (no custom settings yet)
 ├─ yazi/              -> ~/.config/yazi (see yazi/README.md)
 ├─ ghostty/           -> ~/.config/ghostty: config.ghostty + arch/ubuntu/macos.ghostty via os.ghostty
 ├─ arch/              Arch only: Hyprland, hypridle, hyprlock, hyprpaper, waybar (see arch/README.md)
 ├─ ubuntu/            Ubuntu only: GNOME keyboard shortcuts (see ubuntu/README.md)
 └─ macos/             macOS only: AeroSpace, key remap, defaults.sh (see macos/README.md)
```

## Other tools

Not installed by setup; install by hand when needed: gping, jless, mtr, netop, pandoc, sshs, termshark.
