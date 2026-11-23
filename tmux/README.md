# tmux

`tmux.conf` is linked to `~/.config/tmux/tmux.conf` by `setup/link.sh` (only the file: tpm keeps
its plugins in `~/.config/tmux/plugins/`). `setup/link.sh` installs tpm and missing plugins, then
updates them; tmux itself does not wait for a network connection. If installation fails, run
`setup/link.sh` again. If the tpm directory is incomplete, move it aside before retrying.

Prefix is the default `Ctrl-b`. Reload the config with `<prefix> r`.

## Keys

| Keys                         | What it does                                                    |
|------------------------------|-----------------------------------------------------------------|
| `Ctrl-h/j/k/l`               | move between panes, and between Vim/Neovim splits (tmux.nvim)   |
| `<prefix> Ctrl-l`            | clear the screen (plain `Ctrl-l` moves between panes)           |
| `<prefix> G`                 | lazygit in a popup, in the current folder                       |
| `Alt-h/j/k/l`                | resize pane by 1 (passed to Vim when it's in the pane); Linux only, AeroSpace takes these on macOS |
| `Ctrl-Shift-Left/Right`      | previous / next window                                          |
| `Alt-p` / `Alt-n`            | move the current window one place left / right                  |
| `<prefix> f`                 | pick an open session or a zoxide folder (see Sessions below)    |
| `<prefix> Tab`               | back to the previous session                                    |
| `Ctrl-Shift-Up/Down`         | previous / next session                                         |
| `<prefix> N`                 | new session with a name you type, in the current folder         |
| `<prefix> X`                 | close the current session (asks first)                          |
| `<prefix> $`                 | rename the current session (built in)                           |
| `<prefix> "` / `%` / `c`     | split down / split right / new window, in the current folder    |
| `<prefix> x`                 | close pane without asking                                       |
| `<prefix> u`                 | swap the current pane with a pane picked by number              |
| `<prefix> S`                 | show / hide the status bar                                      |
| copy mode `v` / `V` / `Ctrl-v` | start selection / select line / block selection              |
| copy mode `y` / `Y` / mouse drag | copy selection / line / dragged text to the system clipboard; stays in copy mode |

## Plugins

| Plugin                                                                 | Keys                       |
|------------------------------------------------------------------------|----------------------------|
| [tpm](https://github.com/tmux-plugins/tpm)                             | `<prefix> I` install, `<prefix> U` update, `<prefix> Alt-u` remove unlisted plugins |
| [tmux-fzf-pane-switch](https://github.com/kristijan/tmux-fzf-pane-switch) | `<prefix> s`: fuzzy-find a session, window or pane, shown as a tree, also by the text in a pane; `Alt-J` labels rows to jump to (replaces the session list; needs v3+) |
| [tmux-suspend](https://github.com/MunifTanjim/tmux-suspend)            | `F12`: pass all keys to a nested tmux (e.g. over SSH) |
| [tmux-mode-indicator](https://github.com/MunifTanjim/tmux-mode-indicator) | shows prefix / copy / suspend mode in the status bar |

## Sessions

One session per project, each with its own windows. `<prefix> f` lists open sessions and folders
zoxide knows. A folder is matched by its full path; new sessions use its basename (`.` and `:`
become `_`), with a numbered suffix if the name is taken. Existing sessions without a saved path
are not assumed to belong to a folder. To associate one before picking that folder, run:

```sh
tmux set-option -t 'session-name' @project-dir '/absolute/path/to/project'
```

`<prefix> w` opens tmux's built-in session/window tree.

## Behaviour worth knowing

- Applications can copy through tmux, including over SSH (`set-clipboard on`), but cannot read
  its newest paste buffer using OSC 52 (`get-clipboard off`). Passthrough remains on for images.
- Programs that ask for modified keys get them (`extended-keys on`, CSI u), e.g. Shift+Enter
  inserts a newline in Claude Code; a plain shell gets ordinary keys.
- yazi's image previews work inside tmux (`allow-passthrough on`).
- Closing a session's last window switches to another session (`detach-on-destroy off`).
- A window with new output shows in yellow in the status bar.
- Shell windows are named after their folder, other programs after themselves (`nvim`, `lazygit`).
