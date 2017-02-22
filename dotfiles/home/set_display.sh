#! /bin/bash

main_width=1600
main_higth=900
shine_width=1440
shine_higth=900
main_monitor="LVDS1"
second_monitor="VGA1"
# shine_width=1920
# shine_higth=1080
#shine_width=1920
#shine_higth=1200

set_display()
{
    mx_pos=$((shine_width+10)) # 0
    my_pos=0
    sx_pos=0 # $((main_width+10))
    sy_pos=0
    
    xrandr --output ${main_monitor} --primary --mode $((main_width))x$((main_higth)) --pos $((mx_pos))x$((my_pos)) --output ${second_monitor} --mode $((shine_width))x$((shine_higth)) --pos $((sx_pos))x$((sy_pos))
    # xrandr --output LVDS1 --primary --auto --output VGA1 --auto --right-of LVDS1
    
    # #[left of]
    # xrandr --output VGA1 --mode 1360x768 --pos 0x0 --output HDMI1 --mode 1920x1080 --pos 1360x0

    # #[right of]
    # xrandr --output VGA1 --mode 1024x768 --pos 1920x0 --output HDMI1 --mode 1024x768 --pos 0x0

    # #[above of]
    # xrandr --output VGA1 --preferred --output HDMI1 --mode 1920x1080 --pos 0x768

    # #[below of]
    # xrandr --output VGA1 --mode 1024x768 --pos 0x768 --output HDMI1 --mode 1024x768 --pos 0x0
}
# set_display

# ----- main -----
usage() {
    echo "usage: $0 -m mode [home|office]"
    exit 1
}

MODE="home"

while getopts ":hm:" opt; do
    case $opt in
        m)
            MODE="$OPTARG"
            ;;
        h)
            usage
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            usage
            ;;
    esac
done

main() {
    echo "get mode: $MODE"
    case $MODE in
        "home")
            echo ">> mode: home"
            shine_width=1440
            shine_higth=900
            main_monitor="LVDS1"
            second_monitor="VGA1"
            set_display
            ;;
        "office")
            echo ">> mode: office"
            shine_width=2560
            shine_higth=1440
            main_monitor="LVDS-1-1"
            second_monitor="DP-3"
            set_display
            ;;
    esac
}
# === main ===
if [[ "${BASH_SOURCE[0]}" == "$0" ]];then
    main "$*"
fi

