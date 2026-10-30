# tmux

`tmux.conf` is linked to `~/.config/tmux/tmux.conf` by `setup/link.sh` (only the file: tpm keeps
its plugins in `~/.config/tmux/plugins/`). On first start tmux clones tpm and installs the plugins itself.

Prefix is the default `Ctrl-b`. Reload the config with `<prefix> r` (safe to repeat; nothing is added twice).

## Keys

| Keys                         | What it does                                                    |
|------------------------------|-----------------------------------------------------------------|
| `Ctrl-h/j/k/l`               | move between panes, and between Vim/Neovim splits (tmux.nvim)   |
| `Alt-h/j/k/l`                | resize pane by 1 (passed to Vim when it's in the pane); Linux only: on macOS AeroSpace takes these keys |
| `Ctrl-Shift-Left/Right`      | previous / next window                                          |
| `Alt-p` / `Alt-n`            | move the current window one place left / right                  |
| `<prefix> "` / `%` / `c`     | split down / split right / new window, in the current folder    |
| `<prefix> x`                 | close pane without asking                                       |
| `<prefix> u`                 | swap the current pane with a pane picked by number              |
| `<prefix> S`                 | show / hide the status bar                                      |
| copy mode `v` / `V` / `Ctrl-v` | start selection / select line / block selection              |
| copy mode `y` / `Y`          | copy selection / copy line (to the system clipboard)            |

## Plugins

| Plugin                                                                 | Keys                       |
|------------------------------------------------------------------------|----------------------------|
| [tpm](https://github.com/tmux-plugins/tpm)                             | `<prefix> I` install, `<prefix> U` update, `<prefix> Alt-u` remove unlisted plugins |
| [tmux-fzf-pane-switch](https://github.com/kristijan/tmux-fzf-pane-switch) | `<prefix> s`: fuzzy-find a pane across sessions (replaces the built-in session list) |
| [tmux-suspend](https://github.com/MunifTanjim/tmux-suspend)            | `F12`: pass all keys to a nested tmux (e.g. over SSH) |
| [tmux-mode-indicator](https://github.com/MunifTanjim/tmux-mode-indicator) | shows prefix / copy / suspend mode in the status bar |

## Notes

- **Shift+Enter** and other modified keys reach programs that ask for them (`extended-keys on`,
  CSI-u format), e.g. Shift+Enter inserts a newline in Claude Code and Pi; a plain shell gets
  ordinary keys. These are the settings Claude Code's and Pi's docs recommend for tmux.
- **Image previews** (yazi) work inside tmux because `allow-passthrough` is on.
- **Closing the last window** of a session switches to another session (`detach-on-destroy off`).
- **Colours**: One Dark, set as `od_*` variables near the top of the colours section; a window with
  new output shows in yellow in the status bar.
