# Set keyboard repeat rate
xset r rate 200 30

# Load .Xresources for xterm colour scheme
xrdb ~/.Xresources

# Set natural scrolling
xinput set-prop 13 276 -26 -26

# Execute i3 windows manager
exec i3

# Source xmodmap
[ -f ~/.xmodmap ] && xmodmap ~/.xmodmap
