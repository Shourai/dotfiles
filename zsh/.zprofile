# Start Hyprland when logging in on TTY1 (Arch), but not from a shell that's already inside
# a graphical session (e.g. a tmux pane) or where Hyprland isn't installed (Ubuntu, macOS).
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && command -v start-hyprland >/dev/null; then
  exec start-hyprland
fi
