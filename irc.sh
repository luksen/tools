#!/bin/bash
 
if [ -n $TMUX ]
then
    suffix=0
    while [ -e "out$suffix" ]
    do
        suffix=$[suffix + 1]
    done
 
    tmux split-window -l 1 "sic $* > out$suffix"
    tail -F "out$suffix" 
else
    tmux new-session "$0 $*"
fi
