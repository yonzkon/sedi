# .bash_profile

# PS1
[ -z $ZSH ] && PS1="[\u@\H \W \A #\#]$ "

# TERM
export TERM=xterm-256color

# xfce4-terminal
export LC_ALL="en_US.UTF-8"

# PATH
#PATH=$(sed 's#\(:\{0,1\}\)/opt/bin[^:]*:\{0,1\}#\1#' <<<$PATH)
OPTWARE=""
OPTPATH=$(sed 's#[^ ]*#/opt/&#g' <<<$OPTWARE)
for d in $(echo $OPTPATH); do
    if [[ ! $PATH =~ $d ]]; then
        [ -d "$d/bin" ] && PATH=$d/bin:$PATH
        [ -d "$d/sbin" ] && PATH=$d/sbin:$PATH
    fi
done

if [[ ! $PATH =~ "mss" ]]; then
    MSS="$HOME/.mss"
    [ -d "$MSS" ] && PATH=$MSS/bin:$MSS/etc/.vim/bundle/YCM-generator:$PATH
fi

PATH=$HOME/.local/bin:/usr/local/bin:$PATH
export PATH

# android for mac
# export ANDROID_HOME=$HOME/Library/Android/sdk
# export PATH=$PATH:$ANDROID_HOME/tools
# export PATH=$PATH:$ANDROID_HOME/tools/bin
# export PATH=$PATH:$ANDROID_HOME/platform-tools
# export PATH=$PATH:$ANDROID_HOME/emulator

# for gcc & ld
export C_INCLUDE_PATH=/usr/local/include
export CPLUS_INCLUDE_PATH=/usr/local/include
export LIBRARY_PATH=/usr/local/lib
export LD_LIBRARY_PATH=/usr/local/lib
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
Linux|CYGWIN*|MINGW*|MSYS*)
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
alias vi="vim"
alias grep="grep --color=auto"
alias jobs="jobs -l"
alias df="df -T"
