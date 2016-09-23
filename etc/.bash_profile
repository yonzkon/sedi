# .bash_profile

# if running bash
#if [ -n "$BASH_VERSION" ]; then
#    # include .bashrc if it exists
#    if [ -f "$HOME/.bashrc" ]; then
#        . "$HOME/.bashrc"
#    fi
#fi

# env
test $(id -u) -eq 0 && PS1="[\u@\H \W \A #\#]# " || PS1="[\u@\H \W \A #\#]$ "

if [ -d "/home/yiend/" ]; then
	export Y=/home/yiend
	export YD=/home/yiend/yd
fi

if [ -d "$HOME/.mss/" ] && [ -z "$MSS" ]; then
	export MSS=$HOME/.mss
	export PATH=$PATH:$MSS/bin
fi

# for gcc & ld
#export C_INCLUDE_PATH=
#export CPLUS_INCLUDE_PATH=
#export LIBRARY_PATH=
#export LD_LIBRARY_PATH=
#export HISTSIZE=2400

# alias
[ $(id -u) -eq 0 ] && alias his="history 50" || alias his="history 2400"
alias ls="ls --color=auto"
alias ll="ls -l --color=auto"
alias l.="ls -dl .* --color=auto"
alias la="ls -al --color=auto"
alias grep="grep --color=auto"
alias jobs="jobs -l"
alias df="df -T"

alias vimd="vim -c 'colorscheme default'"
alias vimm="vim -c 'colorscheme molokai' -c 'set t_Co=256'"
alias gvim="gvim --servername GVIM --remote-silent"
alias svim="gvim --servername GVIM --remote-silent"
alias ctags_cpp="ctags -R --c++-kinds=+px --fields=+aiKSz --extra=+q"
alias yuml="yum --disablerepo=base --disablerepo=updates --disablerepo=extras --enablerepo=Local"
