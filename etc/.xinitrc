#!/bin/sh

export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE="fcitx"
export GTK_IM_MODULE="fcitx"

[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap

fcitx -d
#emacs --daemon &

exec cinnamon-session
