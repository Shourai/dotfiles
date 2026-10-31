#!/usr/bin/env bash
# GNOME keyboard shortcuts on Ubuntu, close to the Arch (Hyprland) ones.
# Run by setup/ubuntu.sh; needs a running GNOME session (gsettings). Safe to rerun.
# Keys: see ubuntu/README.md.

set -euo pipefail

# Full paths: GNOME starts shortcut commands without the shell's PATH, and on Ubuntu
# tmux comes from Homebrew
ghostty="$(command -v ghostty || echo /usr/bin/ghostty)"
tmux=/home/linuxbrew/.linuxbrew/bin/tmux
[ -x "$tmux" ] || tmux="$(command -v tmux || echo tmux)"

# name | keys | command
shortcuts=(
  "ghostty|<Super>Return|$ghostty"
  "ghostty-tmux|<Super><Shift>Return|$ghostty -e $tmux"
  "ghostty-tmux-ctrl-alt-t|<Control><Alt>t|$ghostty -e $tmux"
)

# Ubuntu's own gsettings: Homebrew's (pulled in with GLib by e.g. poppler, and first on PATH)
# has no dconf support and silently writes to a file GNOME never reads
gsettings=/usr/bin/gsettings

media=org.gnome.settings-daemon.plugins.media-keys
base=/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings

# Ctrl+Alt+T normally opens Ubuntu's own terminal; free it for the shortcut above
$gsettings set "$media" terminal "[]"

# Add our shortcuts to GNOME's list of custom shortcuts, keeping any made by hand
paths=""
for entry in "${shortcuts[@]}"; do
  IFS='|' read -r name keys command <<<"$entry"
  path="$base/dotfiles-$name/"
  $gsettings set "$media.custom-keybinding:$path" name "$name"
  $gsettings set "$media.custom-keybinding:$path" binding "$keys"
  $gsettings set "$media.custom-keybinding:$path" command "$command"
  paths="$paths $path"
done

current="$($gsettings get "$media" custom-keybindings)"
merged="$(python3 -c '
import ast, sys
current = sys.argv[1].removeprefix("@as ")
ours = sys.argv[2].split()
paths = [p for p in ast.literal_eval(current) if "/dotfiles-" not in p] + ours
print(str(paths))
' "$current" "$paths")"
$gsettings set "$media" custom-keybindings "$merged"

echo "GNOME shortcuts set: Ctrl+Alt+T and Super+Shift+Return = ghostty + tmux, Super+Return = ghostty"
