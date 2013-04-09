#! /bin/bash

main_width=1600
main_higth=900
shine_width=1440
shine_higth=900

set_display()
{
    mx_pos=0
    my_pos=0
    sx_pos=$((main_width+10))
    sy_pos=0
    
    xrandr --output LVDS1 --mode $((main_width))x$((main_higth)) --pos $((mx_pos))x$((my_pos)) --output VGA1 --mode $((shine_width))x$((shine_higth)) --pos $((sx_pos))x$((sy_pos)) 
}

# #[left of]
# xrandr --output VGA1 --mode 1360x768 --pos 0x0 --output HDMI1 --mode 1920x1080 --pos 1360x0

# #[right of]
# xrandr --output VGA1 --mode 1024x768 --pos 1920x0 --output HDMI1 --mode 1024x768 --pos 0x0

# #[above of]
# xrandr --output VGA1 --preferred --output HDMI1 --mode 1920x1080 --pos 0x768

# #[below of]
# xrandr --output VGA1 --mode 1024x768 --pos 0x768 --output HDMI1 --mode 1024x768 --pos 0x0

set_display
