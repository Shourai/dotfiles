# Arch Linux

Install: see Prerequisites in the [main README](../README.md#prerequisites). After `install`,
Hyprland starts on every TTY1 login (`zsh/.zprofile`).

## Desktop

`setup/link.sh` links `wayland/hypr` to `~/.config/hypr` and `wayland/waybar` to `~/.config/waybar`.

| File                  | What it does                                         | Apply changes                       |
|-----------------------|------------------------------------------------------|-------------------------------------|
| `hypr/hyprland.lua`   | monitors, autostart, look, input, keys, window rules | on save (see below)                 |
| `hypr/hypridle.conf`  | lock after 5 min, screen off after 5.5 min           | restart hypridle, or log out and in |
| `hypr/hyprlock.conf`  | lock screen (font: Inter, `inter-font`)              | next lock                           |
| `hypr/hyprpaper.conf` | wallpaper (`hypr/wallpaper.png`)                     | restart hyprpaper, or log out and in |
| `waybar/config.jsonc` | bar: workspaces, window title, submap, volume, clock | `killall -SIGUSR2 waybar`           |
| `waybar/style.css`    | bar fonts and colours (Inter, Symbols Nerd Font)     | `killall -SIGUSR2 waybar`           |

**Monitors**: set for this desktop (DP-2 left with workspaces 1-5, DP-3 right with 6-10). On
another machine, edit the MONITORS block in `hyprland.lua`; `hyprctl monitors` lists the outputs.

**Editing `hyprland.lua`**: every save is live; a mistake shows a red error bar and
`hyprctl configerrors` lists the problems. To check a bigger change first, edit a copy, run
`Hyprland --verify-config -c <copy>`, then copy it over the real file.

## Keys

`SUPER` is the main modifier. Caps Lock is an extra Ctrl.

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
| `SUPER+[` / `SUPER+]`, `SUPER+scroll` | previous / next open workspace on this monitor (scrolling on waybar's workspaces too) |
| `SUPER+S` / `SUPER+SHIFT+S`        | show scratchpad / move window to scratchpad        |
| `SUPER+left drag` / `SUPER+right drag` | move / resize a window                         |
| `SUPER+Space`, then `f` / `b` / `c` | Firefox Dev / Brave incognito / Chromium incognito (`Esc` cancels; needs `--extras`) |
| `SUPER+M`                          | exit Hyprland                                      |
| `ALT+CTRL+Q`                       | lock screen                                        |
| `ALT+CTRL+S`                       | screenshot of a selected area to the clipboard     |
| `ALT+SHIFT+M` / `.` / `,`          | mute / volume up / volume down                     |
| 3-finger swipe (touchpad)          | switch workspace                                   |

## After installation

Manual system tweaks, not done by `install`:

- [Disable the authentication delay](https://github.com/Shourai/til/blob/master/linux/authentication-delay.md)
- [Increase login attempts](https://github.com/Shourai/til/blob/master/linux/increase_login_attempts.md)
- [Set up gnome-keyring](https://github.com/Shourai/til/blob/master/linux/keyring.md)
- [Change the systemd-boot timeout](https://github.com/Shourai/til/blob/master/linux/systemd-boot-timeout.md)
- [Lower the LUKS iter-time](https://github.com/Shourai/til/blob/master/linux/modify-luks-iter-time.md) (archinstall sets 10 s)
- [Hardware video acceleration](https://wiki.archlinux.org/title/Hardware_video_acceleration): Intel Broadwell and newer (incl. Arc) use `intel-media-driver`
- Faster `makepkg`: set `PKGEXT='.pkg.tar'` (no compression) or `'.pkg.tar.lz4'` in `/etc/makepkg.conf`
