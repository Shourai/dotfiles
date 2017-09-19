# Set keyboard repeat rate
xset r rate 200 30

# Load .Xresources for xterm colour scheme
xrdb ~/.Xresources

# Set natural scrolling
xinput set-prop 13 276 -26 -26

# Source xmodmap
[ -f ~/.xmodmap ] && xmodmap ~/.xmodmap

# Wallpaper
feh --bg-scale ~/.config/i3/bg.jpg

# Execute i3 windows manager
exec i3
