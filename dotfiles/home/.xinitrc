#
# ~/.xinitrc
#

#setup XIM environment
export XMODIFIERS="@im=fcitx"
export XIM=fcitx
export XIM_PROGRAM=fcitx
#export GTK_IM_MODULE=xim
#export QT_IM_MODULE=xim
fcitx -r

#for nvidia driver
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto

xbindkeys
#xmodmap .xmodmap
xrdb ~/.Xresources
exec sawfish
#exec enlightenment_start
