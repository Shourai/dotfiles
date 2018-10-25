# Set keyboard repeat rate
xset r rate 200 30

# Load .Xresources for xterm colour scheme
xrdb ~/.Xresources

# Touchpad config
xinput set-prop 13 286 1 # natural scrolling Acer
xinput set-prop 13 278 1 # enabled tapping Acer
xinput set-prop 12 280 1 # natural scrolling Asus
xinput set-prop 12 272 1 # enabled tapping Asus
xinput set-prop 12 287 0.5 # accel speed Asus

# Source xmodmap
[ -f ~/.xmodmap ] && xmodmap ~/.xmodmap

# Wallpaper
feh --bg-scale ~/.config/i3/bg.jpg

# Start dropbox in background
( ( sleep 2 && /usr/bin/dropbox ) & )

# Execute i3 windows manager
exec i3
