#!/bin/bash

[ $# == 1 ] || exit 0


if [[ "$(pidof -s $1)" != "" ]]
then
    i3-msg "[class=\"(?i)$1\"] focus"
else
    i3-msg exec $1
fi
