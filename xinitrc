# Set keyboard repeat rate
xset r rate 200 30

# Load .Xresources for xterm colour scheme
xrdb ~/.Xresources

# Set natural scrolling
xinput set-prop 13 276 -26 -26
xinput set-prop 12 281 1 # natural scrolling Asus
xinput set-prop 12 273 1 # enabled tapping Asus
xinput set-prop 12 288 0.5 # accel speed Asus

# Source xmodmap
[ -f ~/.xmodmap ] && xmodmap ~/.xmodmap

# Wallpaper
feh --bg-scale ~/.config/i3/bg.jpg

# Start dropbox in background
( ( sleep 2 && /usr/bin/dropbox ) & )

# Execute i3 windows manager
exec i3
