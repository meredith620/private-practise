#
# ~/.xinitrc
#

#setup XIM environment
export XMODIFIERS="@im=fcitx"
export XIM=fcitx
export XIM_PROGRAM=fcitx
fcitx -r

# for nvidia driver
#xrandr --setprovideroutputsource modesetting NVIDIA-0
# for nouveau driver
xrandr --setprovideroffloadsink nouveau Intel #Reverse PRIME mode
xrandr --setprovideroutputsource Intel nouveau #enable intel card port
xrandr --auto
xrandr --dpi 96
xbindkeys
#xmodmap .xmodmap
xrdb ~/.Xresources
exec sawfish
#exec enlightenment_start
