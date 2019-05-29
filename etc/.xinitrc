#!/bin/sh

export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE="fcitx"
export GTK_IM_MODULE="fcitx"

[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap

fcitx -d
synapse -s &
#emacs --daemon &

exec xfce4-session
