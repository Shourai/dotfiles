# dotfiles

Configuration for Arch Linux (Hyprland), Ubuntu 26.04 (GNOME) and macOS (AeroSpace).
`install` sets up a clean machine; run it again to update. The Neovim config is a separate repo,
[nvim](https://github.com/Shourai/nvim), which `install` clones too.

OS specifics: [Arch](arch/README.md), [Ubuntu](ubuntu/README.md) (read it: Homebrew's tools
hide Ubuntu's in the shell), [macOS](macos/README.md).

## Prerequisites

- A user with `sudo`, an internet connection and `curl` (Ubuntu: `sudo apt install curl`).
- **Arch**: install with `archinstall`, with no desktop profile and no display manager. Hyprland
  starts on a TTY1 login (`zsh/.zprofile`); a login screen would bypass that.
- **Ubuntu**: 26.04 LTS or newer, standard GNOME desktop.
- **macOS**: nothing; `install` installs Homebrew, which installs the Xcode command line tools.
- The repos must be at `~/Documents/github/dotfiles` and `~/Documents/github/nvim`: scripts and
  some configs (e.g. `arch/wayland/hypr/hyprpaper.conf`) hard-code these paths.
- To push: an SSH key on GitHub (`install` clones over https, then switches the remotes to SSH).
  The shell uses Bitwarden's or 1Password's SSH agent if you install one and turn its agent on;
  see [zsh](zsh/README.md#ssh-agent).

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/Shourai/dotfiles/main/install | bash
curl -fsSL https://raw.githubusercontent.com/Shourai/dotfiles/main/install | bash -s -- --extras   # with flags
```

| Flag         | Effect                                                                         |
|--------------|--------------------------------------------------------------------------------|
| `--extras`   | Arch: also install `packages/extras-*.txt` (browsers, 1Password, ...) |
| `--defaults` | macOS: also apply `macos/defaults.sh` (read it first: it empties the Dock)     |
| `--keyremap` | macOS: also install the key remap for non-US Mac keyboards (breaks `\` on US ones) |
| `--dry-run`  | print what would change, change nothing (needs the repos cloned already)       |

`install` installs git, clones both repos (or `git pull --ff-only`s them; on local changes it warns
and uses them as they are), then runs the scripts below. Every script takes the same flags and can
be run on its own. A failing script doesn't stop the others; `install` lists the failures at the end.
Safe to rerun. Log out and back in afterwards.

| Script            | What it does                                                                  |
|-------------------|-------------------------------------------------------------------------------|
| `setup/arch.sh`   | `pacman -Syu`, yay, the pacman and AUR lists, clears the pacman cache          |
| `setup/ubuntu.sh` | `apt upgrade`, the apt list, Snaps, Homebrew with the shared lists, `brew upgrade`, GNOME shortcuts |
| `setup/macos.sh`  | Homebrew formulae and casks, `brew upgrade`; key remap and `defaults.sh` with flags |
| `setup/link.sh`   | links the configs into `~/.config`, picks the per-OS ghostty file, `ya pkg install` |
| `setup/zsh.sh`    | `ZDOTDIR` in the system zshenv, zsh as login shell, clones or updates the zsh plugins |

## Update

```sh
~/Documents/github/dotfiles/install
```

Pulls both repos, upgrades all packages, relinks and updates the zsh plugins. Plugins that the
tools manage themselves:

| What                 | How                                                     |
|----------------------|---------------------------------------------------------|
| Neovim plugins       | `:Lazy sync`, `:MasonUpdate`, `:TSUpdate` (see the nvim README) |
| tmux plugins         | `<prefix> U`                                            |
| yazi flavors/plugins | `ya pkg upgrade`                                        |

## Common tasks

**Add a package**: add a line to the right list in `packages/` and run `install` (or
`setup/<os>.sh`). Both also upgrade everything else; to get one package now, install it by hand
and add it to the list for next time.

| List              | Installed with                                                  |
|-------------------|-----------------------------------------------------------------|
| `common.txt`      | pacman on Arch, Homebrew on macOS and Ubuntu (same name on both) |
| `pacman.txt`      | pacman (Arch)                                                   |
| `aur.txt`         | yay (Arch)                                                      |
| `brew.txt`        | Homebrew (macOS and Ubuntu)                                     |
| `brew-macos.txt`  | Homebrew (macOS)                                                |
| `cask.txt`        | Homebrew casks (macOS apps and fonts)                           |
| `apt.txt`         | apt (Ubuntu)                                                    |
| `snap.txt`        | Snap (Ubuntu)                                                   |
| `extras-pacman.txt`, `extras-aur.txt` | Arch, only with `--extras`                  |

yazi's preview helpers are in each OS's own list (`pacman.txt`, `brew-macos.txt`, `apt.txt`).

**Add a config**: put it in the repo, add a `link` line to `setup/link.sh`, run `setup/link.sh`.
Anything already at the target is moved to `<name>.bak-<date>`, never deleted.

**Remove a config**: delete it and its `link` line, run `setup/link.sh`: it removes broken links
directly in `~/.config` that point into the repo. Remove deeper links (e.g.
`~/.config/tmux/tmux.conf`) by hand.

**Change keys or settings**: see the folder's README: [zsh](zsh/README.md),
[tmux](tmux/README.md), [git](git/README.md), [yazi](yazi/README.md), [Arch](arch/README.md),
[Ubuntu](ubuntu/README.md), [macOS](macos/README.md).

## Per machine

| What                                | Where                                                          |
|-------------------------------------|----------------------------------------------------------------|
| Monitors and workspaces (Arch)      | MONITORS block in `arch/wayland/hypr/hyprland.lua`; `hyprctl monitors` lists the outputs |
| Workspaces per monitor (macOS)      | `[workspace-to-monitor-force-assignment]` in `macos/aerospace.toml` |
| Work git identity                   | create `~/.config/git/gitconfig_work` by hand ([git](git/README.md)) |
| Optional parts                      | the flags above: `--extras` (Arch; the browser keys need it), `--keyremap`, `--defaults` (macOS) |

## Troubleshooting

| Problem                                   | Fix                                                                    |
|-------------------------------------------|------------------------------------------------------------------------|
| `install` lists failed steps              | read the messages above the list, fix the cause, run `install` again    |
| A link replaced something you needed      | it's next to it as `<name>.bak-<date>`: remove the link, rename the backup back |
| Plain prompt (no pure), no SSH host completion | the zsh plugins aren't cloned yet: run `setup/zsh.sh`              |
| zsh ignores its config (no prompt, aliases) | `ZDOTDIR` must be set in `/etc/zsh/zshenv` (Arch, apt's zsh) or `/etc/zshenv` (macOS, Homebrew's zsh): run `setup/zsh.sh` |
| `setup/zsh.sh` warns about two zsh histories | a shell started before the move still writes to `dotfiles/zsh/history`: run `exec zsh` in open shells, merge what you want to keep into `~/.local/state/zsh/history`, delete `dotfiles/zsh/history` (gitignored) |
| Can't log in on Ubuntu after a `brew upgrade` | Homebrew's zsh broke: boot into recovery mode, root shell, `chsh -s /usr/bin/zsh <user>` (if the disk is read-only, first `mount -o remount,rw /`) |
| ghostty settings missing (font, Alt key)  | `ghostty/os.ghostty` is missing: run `setup/link.sh`                    |
| Hyprland shows a red config error         | `hyprctl configerrors` ([Arch](arch/README.md))                         |
| Undo `--keyremap` or `--defaults`         | see [macOS](macos/README.md)                                            |

## Uninstall

1. Remove the links in `~/.config` that point into the repos; rename any `<name>.bak-<date>` back.
2. Delete the `export ZDOTDIR=...` line from `/etc/zsh/zshenv` and, on macOS or with Homebrew's
   zsh, from `/etc/zshenv`.
3. Pick another login shell, e.g. `chsh -s /bin/bash`.
4. macOS: undo `--keyremap` / `--defaults` ([macOS](macos/README.md)).

Packages stay installed.

## Theme

One Dark everywhere (the palette of nvim's `onedark.nvim`, `dark` style).

| Tool              | Where it's set                                                             |
|-------------------|----------------------------------------------------------------------------|
| ghostty           | `theme = One Half Dark` in `ghostty/config.ghostty`                         |
| yazi, lazygit, fzf | nowhere: they use the terminal's colours                                  |
| pure, eza, autosuggestions | fixed colours in `zsh/.zshrc` and `zsh/.zshenv` (`147`, `xx=37`, `#808080`) |
| bat               | `BAT_THEME` in `zsh/.zshrc`                                                 |
| tmux              | `od_*` variables in `tmux/tmux.conf`                                        |
| waybar            | `@define-color` lines in `arch/wayland/waybar/style.css`                    |
| Hyprland borders  | `col` in `arch/wayland/hypr/hyprland.lua`                                   |
| hyprlock          | its own white/grey colours in `arch/wayland/hypr/hyprlock.conf`             |
| nvim              | `onedark.nvim` in the nvim repo                                             |

## Layout

```
dotfiles
 ├─ install            set up or update (see above)
 ├─ setup/             the scripts run by install; shared helpers in lib.sh
 ├─ packages/          package lists
 ├─ zsh/               -> ~/.config/zsh
 ├─ tmux/tmux.conf     -> ~/.config/tmux/tmux.conf
 ├─ git/               -> ~/.config/git
 ├─ lazygit/config.yml -> ~/.config/lazygit/config.yml (no custom settings yet)
 ├─ yazi/              -> ~/.config/yazi
 ├─ ghostty/           -> ~/.config/ghostty (os.ghostty links to the arch/ubuntu/macos file)
 ├─ arch/              Hyprland, hypridle, hyprlock, hyprpaper, waybar
 ├─ ubuntu/            GNOME keyboard shortcuts
 └─ macos/             AeroSpace, key remap, defaults.sh
```

Not installed by setup, install by hand when needed: gping, jless, mtr, netop, pandoc, sshs, termshark.
