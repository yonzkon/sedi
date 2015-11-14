# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi



# set environ
export HISTSIZE=2400
export PATH="${PATH}:/home/munie/bin/"
export PROG=/home/munie/prog
export MNN=/home/munie/prog/mnn
#export C_INCLUDE_PATH=$MNN/libmsort:$MNN/libmutil
#export CPLUS_INCLUDE_PATH=$MNN/libmsort:$MNN/libmutil
#export LIBRARY_PATH=$MNN/libmsort:$MNN/libmutil

# set PS1
test $(id -u) -eq 0 && PS1='[\u@\H \W \A #\#]# ' || PS1='[\u@\H \W \A #\#]$ '

# set alias
alias ls='ls -F --color=auto'
alias ll='ls -liF --color=auto'
alias l.='ls -dliF .* --color=auto'
alias la='ls -liaF --color=auto'
alias grep='grep --color=auto'
alias jobs='jobs -l'
test $(id -u) -eq 0 && alias his='history 2400' || alias his='history 50'

alias df='df -T'
alias yuml='yum --disablerepo=base --disablerepo=updates --disablerepo=extras --enablerepo=Local'

alias ctags_cpp='ctags -R --c++-kinds=+px --fields=+aiKSz --extra=+q'
#test $(id -u) -eq 0 && alias vim='vim -u /home/munie/etc/.vimrc -c "colorscheme molokai"' || alias vim='vim -u /home/munie/etc/.vimrc -c "colorscheme molokai"'
#test $(id -u) -eq 0 && alias vim='vim -c "colorscheme delek"' || alias vim='vim -c "colorscheme molokai"'
alias vimd='vim -c "colorscheme default"'
alias vimm='vim -c "colorscheme molokai" -c "set t_Co=256"'
