# Arch Linux

Install Arch Linux with `archinstall` (no desktop profile, no display manager), log in on TTY1 and
run the `curl ... | bash` command from the main README. Hyprland then starts on every TTY1 login
(`zsh/.zprofile`). The browsers used by `SUPER+Space` come from `--extras`.

## Desktop

`setup/link.sh` links `wayland/hypr` to `~/.config/hypr` and `wayland/waybar` to `~/.config/waybar`.

| File                     | What it does                                                    |
|--------------------------|-----------------------------------------------------------------|
| `hypr/hyprland.lua`      | monitors, autostart, look, input, keys, window rules            |
| `hypr/hypridle.conf`     | lock after 5 min, screen off after 5.5 min                       |
| `hypr/hyprlock.conf`     | lock screen (font: Inter, from `inter-font`)                    |
| `hypr/hyprpaper.conf`    | wallpaper (`hypr/wallpaper.png`)                                |
| `waybar/config.jsonc`    | bar: workspaces, window title, submap, volume, clock            |
| `waybar/style.css`       | bar fonts and colours (text Inter, icons Symbols Nerd Font)     |

**Monitors** are set for this desktop (DP-2 left, DP-3 right; workspaces 1-5 and 6-10 pinned to
them). On another machine, edit the MONITORS block in `hyprland.lua`; `hyprctl monitors` lists the
output names.

**Changing `hyprland.lua`**: Hyprland reloads it as soon as it's saved, so a mistake shows up
right away (a red error bar; `hyprctl configerrors` lists the problems). To check a bigger change
first, edit a copy, run `Hyprland --verify-config -c <copy>`, then copy it over the real file.
hypridle, hyprpaper and waybar don't reload by themselves: restart hypridle or hyprpaper (or log
out and in), and reload waybar with `killall -SIGUSR2 waybar`.

### Keys

`SUPER` is the main modifier. Caps Lock is an extra Ctrl (`kb_options = "ctrl:nocaps"`).

| Keys                               | What it does                                       |
|------------------------------------|----------------------------------------------------|
| `SUPER+Return` / `SUPER+SHIFT+Return` | ghostty / ghostty with tmux                     |
| `SUPER+D`                          | launcher (walker)                                  |
| `SUPER+E`                          | yazi in ghostty                                    |
| `SUPER+W`                          | close window                                       |
| `SUPER+V` / `SUPER+P` / `SUPER+T`  | float / pseudo-tile / toggle split direction       |
| `SUPER+H/J/K/L`                    | focus left / down / up / right                     |
| `SUPER+SHIFT+H/J/K/L`              | move window left / down / up / right               |
| `SUPER+1..0` / `SUPER+SHIFT+1..0`  | go to / move window to workspace 1-10              |
| `SUPER+[` / `SUPER+]`, `SUPER+scroll` | previous / next workspace on this monitor (waybar scroll does the same) |
| `SUPER+S` / `SUPER+SHIFT+S`        | show scratchpad / move window to scratchpad        |
| `SUPER+left drag` / `SUPER+right drag` | move / resize a window                         |
| `SUPER+Space`, then `f` / `b` / `c` | Firefox Dev / Brave incognito / Chromium incognito (`Esc` cancels; needs `--extras`) |
| `SUPER+M`                          | exit Hyprland                                      |
| `ALT+CTRL+Q`                       | lock screen                                        |
| `ALT+CTRL+S`                       | screenshot of a selected area to the clipboard     |
| `ALT+SHIFT+M` / `.` / `,`          | mute / volume up / volume down                     |
| 3-finger swipe (touchpad)          | switch workspace                                   |

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
