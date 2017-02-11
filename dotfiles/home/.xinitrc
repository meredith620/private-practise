#
# ~/.xinitrc
#

#setup XIM environment
export XMODIFIERS="@im=fcitx"
export XIM=fcitx
export XIM_PROGRAM=fcitx
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim
fcitx -r

xbindkeys
#xmodmap .xmodmap
xrdb ~/.Xresources
exec sawfish
#exec enlightenment_start
