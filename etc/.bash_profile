# .bash_profile

# set env
# if running bash
#if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
#    if [ -f "$HOME/.bashrc" ]; then
#        . "$HOME/.bashrc"
#    fi
#fi

if [ -d "$HOME/.mss/" ] && [ -z "$MSS" ]; then
    export MSS=$HOME/.mss/
    PATH=$PATH:$MSS/bin
fi

if [ -d "/home/yiend/" ]; then
    export Y=/home/yiend/
fi

export HISTSIZE=2400
#export C_INCLUDE_PATH=$MNN/libmsort:$MNN/libmutil
#export CPLUS_INCLUDE_PATH=$MNN/libmsort:$MNN/libmutil
#export LIBRARY_PATH=$MNN/libmsort:$MNN/libmutil

# set PS1
test $(id -u) -eq 0 && PS1="[\u@\H \W \A #\#]# " || PS1="[\u@\H \W \A #\#]$ "

# set alias
#alias ls="ls -F --color=auto"
#alias ll="ls -liF --color=auto"
#alias l.="ls -dliF .* --color=auto"
#alias la="ls -liaF --color=auto"
alias ll="ls -l --color=auto"
alias l.="ls -dl .* --color=auto"
alias grep="grep --color=auto"
alias jobs="jobs -l"
[ $(id -u) -eq 0 ] && alias his="history 2400" || alias his="history 50"
alias df="df -T"

alias ctags_cpp="ctags -R --c++-kinds=+px --fields=+aiKSz --extra=+q"
#[ $(id -u) -eq 0 ] && alias vim="vim -u /home/munie/etc/.vimrc -c 'colorscheme molokai'" || alias vim="vim -u /home/munie/etc/.vimrc -c 'colorscheme molokai'"
#[ $(id -u) -eq 0 ] && alias vim="vim -c 'colorscheme delek'" || alias vim="vim -c 'colorscheme molokai'"
alias vimd="vim -c 'colorscheme default'"
alias vimm="vim -c 'colorscheme molokai' -c 'set t_Co=256'"

alias yuml="yum --disablerepo=base --disablerepo=updates --disablerepo=extras --enablerepo=Local"
