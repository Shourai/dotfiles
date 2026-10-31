# tmux

`tmux.conf` is linked to `~/.config/tmux/tmux.conf` by `setup/link.sh` (only the file: tpm keeps
its plugins in `~/.config/tmux/plugins/`). On first start tmux installs tpm and the plugins itself.

Prefix is the default `Ctrl-b`. Reload the config with `<prefix> r`.

## Keys

| Keys                         | What it does                                                    |
|------------------------------|-----------------------------------------------------------------|
| `Ctrl-h/j/k/l`               | move between panes, and between Vim/Neovim splits (tmux.nvim)   |
| `Alt-h/j/k/l`                | resize pane by 1 (passed to Vim when it's in the pane); Linux only, AeroSpace takes these on macOS |
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
| [tmux-fzf-pane-switch](https://github.com/kristijan/tmux-fzf-pane-switch) | `<prefix> s`: fuzzy-find a pane across sessions (replaces the session list) |
| [tmux-suspend](https://github.com/MunifTanjim/tmux-suspend)            | `F12`: pass all keys to a nested tmux (e.g. over SSH) |
| [tmux-mode-indicator](https://github.com/MunifTanjim/tmux-mode-indicator) | shows prefix / copy / suspend mode in the status bar |

## Behaviour worth knowing

- Programs that ask for modified keys get them (`extended-keys on`, CSI u), e.g. Shift+Enter
  inserts a newline in Claude Code; a plain shell gets ordinary keys.
- yazi's image previews work inside tmux (`allow-passthrough on`).
- Closing a session's last window switches to another session (`detach-on-destroy off`).
- A window with new output shows in yellow in the status bar. Colours: the `od_*` variables.
