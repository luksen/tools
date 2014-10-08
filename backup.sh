#!/bin/bash

dest="/media/raft/thinkpad.bak"
exfile="$(dirname $0)/data/backup.exclude"
opts="-aAXh --delete-delay --delete-excluded"
info="REMOVE,DEL,MISC,MOUNT,SKIP,STATS"

if [[ $(id -u) != 0 ]]
then
    echo "Not root, continue?"
    read answer
    if [[ "$answer" != "y" ]]
    then
        exit
    fi
fi
    

if [ $# -eq 1 ]
then
    dest="$1"
fi

echo "excluded:"
while read line
do
    echo "    $line"
done < "$exfile"
echo "command:"
echo "    rsync -$opts / $dest --exclude-from=$exfile --info=$info"
echo

rsync $opts / "$dest" --exclude-from="$exfile" --info="$info"
