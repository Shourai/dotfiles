# yazi

Linked to `~/.config/yazi` by `setup/link.sh`, which then runs `ya pkg install`.

The files hold **only what differs from yazi's defaults**. To change a default, copy just that
setting from [yazi's preset files](https://github.com/sxyazi/yazi/tree/main/yazi-config/preset),
not the whole file (a full copy would hide the defaults of newer yazi versions).

| File           | Contains                                                              |
|----------------|-----------------------------------------------------------------------|
| `yazi.toml`    | wider preview pane (`ratio`), larger image previews                   |
| `keymap.toml`  | my keys, in `prepend_keymap` so they win over the defaults            |
| `theme.toml`   | nothing: no flavor, so colours follow the terminal (One Dark)         |
| `package.toml` | flavors and plugins for `ya pkg` (none yet; written by `ya pkg add`)  |

## My keys

| Key      | What it does                                                      |
|----------|-------------------------------------------------------------------|
| `A`      | create a directory (default: bulk create)                         |
| `Ctrl-x` | drag and drop the selected files with dragon-drop (Arch only: not installed elsewhere) |

`~` or `F1` in yazi lists all keys.

## Flavors and plugins

| Task                   | Command                                         |
|------------------------|-------------------------------------------------|
| add a flavor or plugin | `ya pkg add yazi-rs/flavors:<name>`             |
| install what's listed  | `ya pkg install` (also run by `setup/link.sh`)  |
| update all             | `ya pkg upgrade`                                |

`yazi/flavors/` and `yazi/plugins/` are gitignored; `package.toml` is what's committed.

Preview helpers (also behind the "Show EXIF" / "Show media info" openers, `O`) are in the package
lists, under "yazi".
