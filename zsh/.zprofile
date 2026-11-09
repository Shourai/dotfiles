# --- SESSION START ---

# Start Hyprland when logging in on the TTY1 console (Arch), and nowhere Hyprland isn't installed
# (Ubuntu, macOS). Checks the actual terminal, not inherited variables: a tmux pane keeps the
# server's XDG_VTNR=1 but loses DISPLAY/WAYLAND_DISPLAY after an SSH attach. Terminals, tmux and
# SSH all run on /dev/pts/*, so they never match.
if [[ "$TTY" == /dev/tty1 ]] && (( $+commands[start-hyprland] )); then
  exec start-hyprland
fi
