# macOS

| File                            | What it is                                                             |
|---------------------------------|------------------------------------------------------------------------|
| `aerospace.toml`                | AeroSpace tiling window manager, linked to `~/.config/aerospace/aerospace.toml` |
| `com.local.KeyRemapping.plist`  | key remap for non-US keyboards (see below)                             |
| `defaults.sh`                   | system settings (Dock, Finder, trackpad, keyboard); run with `--defaults` |
| `com.googlecode.iterm2.plist`   | iTerm2 settings, kept as a backup only (ghostty is the terminal)       |

## AeroSpace keys

`alt` is the main modifier; the config is set to reload on save.

| Keys                               | What it does                                       |
|------------------------------------|----------------------------------------------------|
| `alt-enter` / `alt-shift-enter`    | ghostty / ghostty with tmux                        |
| `alt-h/j/k/l`                      | focus left / down / up / right                     |
| `alt-shift-h/j/k/l`                | move window                                        |
| `alt-shift-minus` / `equal`        | smaller / bigger                                   |
| `alt-1..9` / `alt-shift-1..9`      | go to / move window to workspace (1-5 main monitor, 6-9 secondary) |
| `alt-[` / `alt-]` / `alt-tab`      | previous / next / last workspace                   |
| `alt-shift-tab`                    | move workspace to the next monitor                 |
| `alt-slash` / `alt-comma`          | tiles / accordion layout                           |
| `alt-space`, then `f` / `c` / `o`  | Firefox Dev / Chrome Dev / Obsidian (`esc` cancels) |
| `alt-shift-;`, then ...            | service mode: `esc` reload, `r` reset layout, `f` float, `backspace` close others, `alt-shift-h/j/k/l` join |

Fusion 360 and Bambu Studio open as floating windows.


## Key remap
Remapping a mac keyboard which is not in US layout
See also: https://github.com/amarsyla/hidutil-key-remapping-generator

`setup/macos.sh` copies `com.local.KeyRemapping.plist` to `~/Library/LaunchAgents/`; launchd applies it at every login.
To apply it right away: `launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.local.KeyRemapping.plist`.


| From                   | Keycode     | To                     | Keycode     |
|------------------------|-------------|------------------------|-------------|
| backslash              | 0x700000031 | return_or_enter        | 0x700000028 |
| grave_accent_and_tilde | 0x700000035 | backslash (\)          | 0x700000031 |
| non_us_backslash (§/±) | 0x700000064 | grave_accent_and_tilde | 0x700000035 |

## Finding a `defaults write` key
1. `defaults read > a`
2. Open system preferences and change the setting to some other value than the default.
3. `defaults read > b`
4. `diff a b`
