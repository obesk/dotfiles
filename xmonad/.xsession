#trayer --edge top --align right --SetDockType true --SetPartialStrut true \
# --expand true --width 10 --transparent true --tint 0x000000 --height 20 \
# --monitor primary &

# Set the default X cursor to the usual pointer
xsetroot -cursor_name left_ptr


# Set a nice background
feh --bg-fill --no-fehbg ~/.config/wall.png

# Fire up screensaver
xscreensaver -no-splash &

# Power Management
# xfce4-power-manager &

/usr/lib/polkit-gnome-authentication-agent-1 &

compton &

if [ -x /usr/bin/nm-applet ] ; then
   nm-applet --sm-disable &
fi


exec xmonad
