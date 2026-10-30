# yazi

Linked to `~/.config/yazi` by `setup/link.sh`, which then runs `ya pkg install`.

The config files contain **only what differs from yazi's defaults**, so new yazi versions bring
their new defaults along instead of breaking an old copy. To see or change a default, look it up in
[yazi's preset files](https://github.com/sxyazi/yazi/tree/main/yazi-config/preset) and copy just
that setting here.

| File           | Contains                                                              |
|----------------|-----------------------------------------------------------------------|
| `yazi.toml`    | wider preview pane (`ratio`), larger image previews                   |
| `keymap.toml`  | my keys, in `prepend_keymap` so they win over the defaults            |
| `theme.toml`   | no flavor: colours follow the terminal theme (One Dark)               |
| `package.toml` | flavors and plugins for `ya pkg` (written by `ya pkg add`)            |

## My keys

| Key      | What it does                                                      |
|----------|-------------------------------------------------------------------|
| `A`      | create a directory (default: bulk create)                         |
| `Ctrl-x` | drag and drop the selected files with dragon-drop (Arch only; not installed elsewhere) |

Press `~` or `F1` in yazi for all keys.

## Flavors and plugins

None are used right now. If you add one, `yazi/flavors/` and `yazi/plugins/` stay out of the repo;
`ya pkg` installs them from `package.toml`.

| Task                          | Command                                         |
|-------------------------------|-------------------------------------------------|
| install what's listed         | `ya pkg install` (also done by `setup/link.sh`) |
| add a flavor or plugin        | `ya pkg add yazi-rs/flavors:<name>`             |
| update all to latest          | `ya pkg upgrade`                                |

## Preview helpers

The tools behind previews and the "Show EXIF" / "Show media info" openers (`O`) are in the
package lists, marked with "yazi" in `packages/`. Image previews also work inside tmux
(see `tmux/README.md`).
