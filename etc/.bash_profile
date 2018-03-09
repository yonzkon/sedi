# .bash_profile

# PS1
[ -z $ZSH ] && PS1="[\u@\H \W \A #\#]$ "

# TERM
export TERM=xterm-256color

# PATH
#PATH=$(sed 's#\(:\{0,1\}\)/opt/bin[^:]*:\{0,1\}#\1#' <<<$PATH)
OPTWARE="node"
OPTPATH=$(sed 's#[^ ]*#/opt/&#g' <<<$OPTWARE)
for d in $OPTPATH; do
	if [[ ! $PATH =~ $d ]]; then
		[ -d "$d/bin" ] && PATH=$d/bin:$PATH
		[ -d "$d/sbin" ] && PATH=$d/sbin:$PATH
	fi
done

if [[ ! $PATH =~ "mss" ]]; then
	MSS="$HOME/.mss"
	[ -d "$MSS" ] && PATH=$MSS/bin:$MSS/etc/.vim/bundle/YCM-generator:$PATH
fi

PATH=$HOME/.local/bin:$PATH
export PATH

# for gcc & ld
#export C_INCLUDE_PATH=
#export CPLUS_INCLUDE_PATH=
#export LIBRARY_PATH=
#export LD_LIBRARY_PATH=
#export HISTSIZE=2400

# for java
if [ -e "/opt/jdk" ]; then
	export JAVA_HOME=/opt/jdk
	export JRE_HOME=$JAVA_HOME/jre
	export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib
	export PATH=$JAVA_HOME/bin:$PATH
fi

# alias
case $(uname -s) in
Linux|MINGW*|MSYS*)
	alias ls="ls --color=auto"
	alias ll="ls -l --color=auto"
	alias l.="ls -dl .* --color=auto"
	alias la="ls -al --color=auto"
	;;
FreeBSD|Darwin)
	alias ls="ls -G"
	alias ll="ls -l -G"
	alias l.="ls -dl .* -G"
	alias la="ls -al -G"
	;;
esac
alias grep="grep --color=auto"
alias jobs="jobs -l"
alias df="df -T"

# docker
alias arch="docker exec -t archlinux bash -ic '"
alias iarch="docker exec -it archlinux bash -ic '"
alias barch="docker exec -it archlinux bash"
