# macOS

| File                            | What it is                                                             |
|---------------------------------|------------------------------------------------------------------------|
| `aerospace.toml`                | AeroSpace tiling window manager, linked to `~/.config/aerospace/aerospace.toml` |
| `com.local.KeyRemapping.plist`  | key remap for non-US Mac keyboards; installed only with `--keyremap`   |
| `defaults.sh`                   | system settings; applied only with `--defaults`                        |
| `com.googlecode.iterm2.plist`   | iTerm2 settings, a backup only (ghostty is the terminal)               |

## AeroSpace

- On first start, give AeroSpace Accessibility permission when macOS asks.
- There must be no `~/.aerospace.toml`: AeroSpace reports two configs as an error.
- The config reloads on save, but only after one manual reload (`alt-shift-;`, then `esc`).
- AeroSpace takes `alt-h/j/k/l`, so the `Alt-h/j/k/l` resize keys of tmux and nvim don't work here.

`alt` is the main modifier.

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

Autodesk Fusion and Bambu Studio open floating (`[[on-window-detected]]`; `aerospace list-apps`
shows an app's id).

## Key remap (`--keyremap`)

For a Mac keyboard that isn't in US layout. **On a US keyboard it breaks `\`.** `setup/macos.sh`
copies the plist to `~/Library/LaunchAgents/`; it applies from the next login. To apply it now:
`launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.local.KeyRemapping.plist`.
Keycodes: [hidutil key remapping generator](https://github.com/amarsyla/hidutil-key-remapping-generator).

| From                   | Keycode     | To                     | Keycode     |
|------------------------|-------------|------------------------|-------------|
| backslash              | 0x700000031 | return_or_enter        | 0x700000028 |
| grave_accent_and_tilde | 0x700000035 | backslash (\)          | 0x700000031 |
| non_us_backslash (§/±) | 0x700000064 | grave_accent_and_tilde | 0x700000035 |

Undo:

```sh
launchctl bootout gui/$(id -u)/com.local.KeyRemapping
rm ~/Library/LaunchAgents/com.local.KeyRemapping.plist
hidutil property --set '{"UserKeyMapping":[]}'
```

## System settings (`--defaults`)

Read `defaults.sh` first. Besides Finder, trackpad and keyboard preferences it:

- **empties the Dock** of all app icons, on every run;
- moves the Dock to the right, autohides it and shrinks the icons;
- asks for the password immediately after sleep or the screensaver;
- sets a key repeat faster than System Settings allows;
- points iTerm2 at this folder for its settings, if iTerm2 is installed.

Dock, Finder and menu bar changes apply right away, trackpad and keyboard ones after logging out
and in. Undo a setting in System Settings, or with `defaults delete <domain> <key>`.

To find the key for a setting: `defaults read > a`, change it in System Settings,
`defaults read > b`, `diff a b`.
