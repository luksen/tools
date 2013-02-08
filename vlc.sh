#!/bin/bash
# dwb: öv

for pid in $(pidof dwb)
do
    video=$(find /proc/$pid/fd/ -lname /tmp/Flash*)
    if [[ -n "$video" ]]
    then
        vlc $video &
    fi
done
