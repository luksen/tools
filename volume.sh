#!/bin/bash

char=█
timeout=3
font='DejaVu Sans Mono-17'
fg='#ff5f5f'
bg='#1c1c1c'
maxchars=97

volume=$(amixer get Master | sed -ne '/Mono/s/.*\[\(.*\)%\].*/\1/p')
bar=$(for i in $(seq $(( ( maxchars*volume + 50)/100 ))); do printf "$char"; done)

if (( volume == 100 ))
then
	bg=$fg
fi

echo $bar | dzen2 -h 2 -y -2 -p $timeout -e 'onstart=uncollapse' -fg "$fg" -bg "$bg" -fn "$font" -ta l
