if [ -z "$DISPLAY" ] && [ ! -z "$XDG_VTNR" ] && [ "$XDG_VTNR" = 1 ]; then
  exec Hyprland &
fi
