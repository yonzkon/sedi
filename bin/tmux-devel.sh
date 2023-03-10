#!/bin/bash

tmux new-session -s devel -d
tmux split-window -v
tmux split-window -h
tmux selectp -L
tmux selectp -U
#tmux resize-pane -D 10
tmux attach-session -t devel
