# Start Hyprland when logging in on TTY1 (Arch). Skipped where Hyprland isn't installed,
# e.g. on Ubuntu with GNOME, where login shells (tmux panes) would otherwise fail.
if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ] && command -v start-hyprland >/dev/null; then
  exec start-hyprland
fi
