# Ubuntu

Ubuntu 26.04 LTS with GNOME. Packages and the login shell: see the Ubuntu section in the main README.

| File            | What it is                                                              |
|-----------------|-------------------------------------------------------------------------|
| `shortcuts.sh`  | GNOME keyboard shortcuts close to the Arch ones; run by `setup/ubuntu.sh` |

## Keyboard shortcuts

GNOME's own shortcuts stay as they are, except Ctrl+Alt+T.

| Keys                                   | What it does                         | Like on Arch           |
|----------------------------------------|--------------------------------------|------------------------|
| `Ctrl+Alt+T`, `Super+Shift+Return`     | ghostty with a new tmux session      | `SUPER+SHIFT+Return`   |
| `Super+Return`                         | ghostty                              | `SUPER+Return`         |

`shortcuts.sh` needs a running GNOME session, so run it (or `setup/ubuntu.sh`) from a terminal on
the desktop, not over SSH. It's safe to rerun and keeps shortcuts you added in GNOME Settings.
They show up there under Keyboard, View and Customize Shortcuts, Custom Shortcuts, named
`ghostty`, `ghostty-tmux` and `ghostty-tmux-ctrl-alt-t`.

To change a shortcut, edit the list at the top of `shortcuts.sh` and run it again. To give
Ctrl+Alt+T back to Ubuntu's terminal: delete the custom shortcut in GNOME Settings and run
`gsettings reset org.gnome.settings-daemon.plugins.media-keys terminal`.
