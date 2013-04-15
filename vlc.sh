#!/bin/bash
# dwb: öv

for pid in $(pidof plugin-container)
do
    video=$(find /proc/$pid/fd/ -lname /tmp/Flash*)
    if [[ -n "$video" ]]
    then
        vlc $video &
    fi
done
