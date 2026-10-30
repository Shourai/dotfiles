# macOS

| File                            | What it is                                                             |
|---------------------------------|------------------------------------------------------------------------|
| `aerospace.toml`                | AeroSpace tiling window manager, linked to `~/.config/aerospace/aerospace.toml` |
| `com.local.KeyRemapping.plist`  | key remap for non-US Mac keyboards; installed only with `--keyremap`   |
| `defaults.sh`                   | system settings; applied only with `--defaults`                        |
| `com.googlecode.iterm2.plist`   | iTerm2 settings, kept as a backup only (ghostty is the terminal)       |

## AeroSpace

Linked by `setup/link.sh`; there must be no `~/.aerospace.toml` as well (AeroSpace reports two
configs as an error). On first start, macOS asks to give AeroSpace Accessibility permission.
The config reloads on save, but only after one manual reload (`alt-shift-;`, then `esc`).

`alt` is the main modifier. Because AeroSpace takes `alt-h/j/k/l`, the `Alt-h/j/k/l` resize keys
of tmux and nvim don't work on macOS.

| Keys                               | What it does                                       |
|------------------------------------|----------------------------------------------------|
| `alt-enter` / `alt-shift-enter`    | ghostty / ghostty with tmux                        |
| `alt-h/j/k/l`                      | focus left / down / up / right                     |
| `alt-shift-h/j/k/l`                | move window                                        |
| `alt-shift-minus` / `equal`        | smaller / bigger                                   |
| `alt-1..9` / `alt-shift-1..9`      | go to / move window to workspace (1-5 main monitor, 6-9 secondary) |
| `alt-[` / `alt-]` / `alt-tab`      | previous / next / last workspace                   |
| `alt-shift-tab`                    | move the window to the other monitor               |
| `alt-slash` / `alt-comma`          | tiles / accordion layout                           |
| `alt-space`, then `f` / `c` / `o`  | Firefox Dev / Chrome Dev / Obsidian (`esc` cancels) |
| `alt-shift-;`, then ...            | service mode: `esc` reload config, `r` reset layout, `f` float/tile, `backspace` close other windows, `alt-shift-h/j/k/l` join with neighbour, `up`/`down` volume, `shift-down` volume to 0 |

Autodesk Fusion and Bambu Studio open as floating windows (`[[on-window-detected]]` rules; check
an app's id with `aerospace list-apps`).

## Key remap (`--keyremap`)

For a Mac keyboard that isn't in US layout. **On a US keyboard it breaks `\`**, so it's only
installed with `install --keyremap` (or `setup/macos.sh --keyremap`).
See also: https://github.com/amarsyla/hidutil-key-remapping-generator

`setup/macos.sh` copies the plist to `~/Library/LaunchAgents/`; launchd applies it at every login.
Apply it right away with `launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.local.KeyRemapping.plist`.

| From                   | Keycode     | To                     | Keycode     |
|------------------------|-------------|------------------------|-------------|
| backslash              | 0x700000031 | return_or_enter        | 0x700000028 |
| grave_accent_and_tilde | 0x700000035 | backslash (\)          | 0x700000031 |
| non_us_backslash (§/±) | 0x700000064 | grave_accent_and_tilde | 0x700000035 |

To undo:

```sh
launchctl bootout gui/$(id -u)/com.local.KeyRemapping
rm ~/Library/LaunchAgents/com.local.KeyRemapping.plist
hidutil property --set '{"UserKeyMapping":[]}'
```

## System settings (`--defaults`)

Read `defaults.sh` before using it. Besides Finder, trackpad and keyboard preferences it:

- **empties the Dock** (removes all app icons), again on every run;
- moves the Dock to the right, autohides it and shrinks the icons;
- asks for the password immediately after sleep or the screensaver;
- sets a very fast key repeat (faster than System Settings allows);
- points iTerm2 at this folder for its settings, if iTerm2 is installed.

Dock, Finder and menu bar changes apply right away; trackpad and keyboard changes after logging
out and back in. To undo a setting, change it back in System Settings, or remove the key with
`defaults delete <domain> <key>`.

### Finding a `defaults write` key

1. `defaults read > a`
2. Change the setting in System Settings.
3. `defaults read > b`
4. `diff a b`
