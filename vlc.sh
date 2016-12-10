#!/bin/bash

for pid in $(pidof plugin-container)
do
	video=$(find /proc/$pid/fd/ -lname /tmp/Flash*)
	if [[ -n "$video" ]]
	then
		(mplayer --quiet --verbose 0 --play-and-exit --qt-minimal-view $video || mplayer $video)&
	fi
done
