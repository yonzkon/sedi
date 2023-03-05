#!/bin/bash

tmux new-session -s devel -d
tmux split-window -v
tmux resize-pane -D 10
tmux attach-session -t devel
