#!/bin/bash

tmux new-session -s devel -d
tmux rename-window base
tmux new-window -n devel
tmux new-window -n tmp
tmux next-window
tmux attach-session -t devel
