#!/bin/sh

export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx
export GTK_IM_MODULE=fcitx
export LC_CTYPE=zh_CN.UTF-8

[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap

fcitx -d
synapse -s &
#emacs --daemon &

#exec cinnamon-session
exec xfce4-session
