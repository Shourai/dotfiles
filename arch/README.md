# Arch Linux

Install Arch Linux with `archinstall`, then run `install` from the repo root.

## Desktop

Hyprland on Wayland, started from TTY1 by `zsh/.zprofile`. `setup/link.sh` links `wayland/hypr`
to `~/.config/hypr` and `wayland/waybar` to `~/.config/waybar`.

| File                     | What it does                                                    |
|--------------------------|-----------------------------------------------------------------|
| `hypr/hyprland.lua`      | monitors (this desktop: DP-2 + DP-3), look, input, keys, rules  |
| `hypr/hypridle.conf`     | lock after 5 min, screen off after 5.5 min                       |
| `hypr/hyprlock.conf`     | lock screen (font: Inter, from `inter-font`)                    |
| `hypr/hyprpaper.conf`    | wallpaper (`hypr/wallpaper.png`)                                |
| `waybar/config.jsonc`    | bar: workspaces, window title, submap, volume, clock            |
| `waybar/style.css`       | bar styles                                                      |

Hyprland reloads `hyprland.lua` on save. Check it first with
`Hyprland --verify-config -c ~/.config/hypr/hyprland.lua`. Reload waybar with `killall -SIGUSR2 waybar`.

### Keys

`SUPER` is the main modifier.

| Keys                               | What it does                                       |
|------------------------------------|----------------------------------------------------|
| `SUPER+Return` / `SUPER+SHIFT+Return` | ghostty / ghostty with tmux                      |
| `SUPER+D`                          | launcher (walker)                                  |
| `SUPER+E`                          | yazi in ghostty                                    |
| `SUPER+W`                          | close window                                       |
| `SUPER+V` / `SUPER+P` / `SUPER+T`  | float / pseudo-tile / toggle split direction       |
| `SUPER+H/J/K/L`                    | focus left / down / up / right                     |
| `SUPER+SHIFT+H/J/K/L`              | move window left / down / up / right               |
| `SUPER+1..0` / `SUPER+SHIFT+1..0`  | go to / move window to workspace 1-10              |
| `SUPER+[` / `SUPER+]`              | previous / next workspace on this monitor          |
| `SUPER+S` / `SUPER+SHIFT+S`        | show scratchpad / move window to scratchpad        |
| `SUPER+Space`, then `f` / `b` / `c` | Firefox Dev / Brave incognito / Chromium incognito |
| `SUPER+M`                          | exit Hyprland                                      |
| `ALT+CTRL+Q`                       | lock screen                                        |
| `ALT+CTRL+S`                       | screenshot of a selected area to the clipboard     |
| `ALT+SHIFT+M` / `.` / `,`          | mute / volume up / volume down                     |

## After installation

### Disable authentication delay

<https://github.com/Shourai/til/blob/master/linux/authentication-delay.md>

### Increase login attempts

<https://github.com/Shourai/til/blob/master/linux/increase_login_attempts.md>

### Setup gnome-keyring

<https://github.com/Shourai/til/blob/master/linux/keyring.md>

### Change systemd-boot timeout

<https://github.com/Shourai/til/blob/master/linux/systemd-boot-timeout.md>

### Allow for hardware acceleration

<https://wiki.archlinux.org/title/Hardware_video_acceleration>
HD Graphics series starting from Broadwell (2014) and newer (e.g. Intel Arc) are supported by `intel-media-driver`.

### Modify LUKS iter time

<https://github.com/Shourai/til/blob/master/linux/modify-luks-iter-time.md>
The default `iter-time` is set to 10 seconds:

- <https://github.com/archlinux/archinstall/blob/master/archinstall/lib/luks.py#L100>
- <https://github.com/archlinux/archinstall/blob/master/archinstall/lib/models/device.py#L22>

### Makepkg compression

To speed up both packaging and installation, with the tradeoff of having larger package archives, change PKGEXT.

For example, the following skips compression of the package file, which will in turn have no need to be decompressed on install:

```
PKGEXT='.pkg.tar' makepkg
```

As another example, the following uses the LZ4 algorithm, which is focused on speed:

```
PKGEXT='.pkg.tar.lz4' makepkg
```

To make one of these settings permanent, set PKGEXT in /etc/makepkg.conf.
