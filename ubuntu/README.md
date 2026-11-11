# Ubuntu

Ubuntu 26.04 LTS with GNOME; the desktop configs in `arch/` aren't used.

Headless (e.g. Ubuntu Server used over SSH) works too: without `gnome-shell` installed,
`setup/ubuntu.sh` skips `apt-desktop.txt`, the Snaps and the keyboard shortcuts.

## Where things come from

| What                                                          | From                                    | List                          |
|---------------------------------------------------------------|-----------------------------------------|-------------------------------|
| base system, fallback `zsh`, `unzip`, `jq`                    | apt                                     | `packages/apt.txt`            |
| desktop only: `wl-clipboard`, yazi's preview helpers, `7zip` | apt                                     | `packages/apt-desktop.txt`    |
| desktop only: Apple's SF fonts (into `~/.local/share/fonts/apple`; delete it to update) | Apple's downloads (`install_apple_fonts` in `setup/lib.sh`) | - |
| CLI tools (same versions as on macOS), incl. the login shell `zsh` | Homebrew (`/home/linuxbrew/.linuxbrew`) | `common.txt`, `brew.txt` |
| desktop only: ghostty                                         | Snap (apt only has 1.3)                 | `snap.txt`                    |
| Bitwarden, for its SSH agent                                  | Snap, install it by hand (App Center); Homebrew's `bw` has no agent | -   |

## Watch out

- **Homebrew's tools come before Ubuntu's in the shell** (and in tmux, nvim, yazi and scripts
  started from it; not in GNOME, desktop apps or `sudo`). So `bash`, `python3`, `perl`, `openssl`,
  `rsync`, ... are Homebrew's. Homebrew's `python3` and `perl` lack Ubuntu's modules (e.g. `gi`):
  scripts that need them should start with `#!/usr/bin/python3` or `#!/usr/bin/perl`.
- **Keep GLib, D-Bus and GnuPG out of Homebrew**: their `gsettings`, `dbus-*` and `gpg` would hide
  Ubuntu's, and Homebrew's `gsettings` can't change GNOME settings. Before adding a formula, check
  `brew deps <formula>`; if it lists `glib`, `dbus` or `gnupg`, take the package from apt instead
  (that's why yazi's preview helpers come from apt). If it happens anyway, use `/usr/bin/gsettings`.
- **Login shell is Homebrew's zsh.** `setup/zsh.sh` only switches to it if it starts, and
  `setup/ubuntu.sh` switches back to `/usr/bin/zsh` if a `brew upgrade` broke it. A `brew upgrade`
  you run by hand isn't checked; if you can't log in afterwards, see Troubleshooting in the
  [main README](../README.md#troubleshooting).
- **ghostty from apt** comes first on `PATH` if it's still installed: `sudo apt remove ghostty`
  (`setup/ubuntu.sh` warns about it). Ubuntu's own terminal, Ptyxis, stays as a fallback.
- **ghostty runs in the background.** The Snap takes seconds to start the first time after a boot,
  so `ghostty-autostart.desktop` (linked to `~/.config/autostart/`) starts it at login without a
  window, and it keeps running when you close the last window (`quit-after-last-window-closed` in
  `ghostty/ubuntu.ghostty`). The shortcuts open their windows in it over D-Bus (`ghostty-window`),
  not through `/snap/bin/ghostty`, whose wrapper adds 0.3-0.8 s to every shortcut. If it isn't
  running, D-Bus starts it (`ghostty-dbus.service`). Snap updates of ghostty may wait until it
  stops: log out and back in. To stop it for good, remove the autostart and D-Bus links.
- **SSH agent**: in Bitwarden, turn on Settings, "Enable SSH agent", then check in a new terminal
  with `ssh-add -L`. Until Bitwarden runs, GNOME's agent is used.

## Keyboard shortcuts

Set by `shortcuts.sh`, which `setup/ubuntu.sh` runs. GNOME's own shortcuts stay, except Ctrl+Alt+T.

| Keys                               | What it does                    | Like on Arch         |
|------------------------------------|---------------------------------|----------------------|
| `Ctrl+Alt+T`, `Super+Shift+Return` | ghostty with a new tmux session | `SUPER+SHIFT+Return` |
| `Super+Return`                     | ghostty                         | `SUPER+Return`       |

- `shortcuts.sh` needs the GNOME session: run it (or `setup/ubuntu.sh`) from a terminal on the
  desktop, not over SSH. Safe to rerun; shortcuts you made in GNOME Settings stay.
- In GNOME Settings they're under Keyboard, View and Customize Shortcuts, Custom Shortcuts, named
  `ghostty`, `ghostty-tmux` and `ghostty-tmux-ctrl-alt-t`.
- To change one, edit the list at the top of `shortcuts.sh` and run it again.
- To give Ctrl+Alt+T back to Ubuntu's terminal: in `shortcuts.sh`, remove the
  `ghostty-tmux-ctrl-alt-t` entry and the `terminal "[]"` line (or the next `install` sets them
  again), run it (it drops its shortcuts that are no longer listed), then run
  `/usr/bin/gsettings reset org.gnome.settings-daemon.plugins.media-keys terminal`.
