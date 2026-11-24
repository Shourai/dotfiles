# --- SESSION START ---

# Only hand interactive TTY1 logins over to Hyprland; its exit ends the login session.
# Check the actual terminal: a tmux pane can inherit XDG_VTNR=1 from its server.
if [[ -o interactive && "$TTY" == /dev/tty1 ]] && (( $+commands[start-hyprland] )); then
  exec start-hyprland
fi
