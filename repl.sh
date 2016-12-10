#!/bin/bash

cmd=$1
prompt="$cmd>> "


# Colors
black="\e[30m"
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
blue="\e[34m"
magenta="\e[35m"
cyan="\e[36m"
white="\e[37m"
brightBlack="\e[30;1m"
brightRed="\e[31;1m"
brightGreen="\e[32;1m"
brightYellow="\e[33;1m"
brightBlue="\e[34;1m"
brightMagenta="\e[35;1m"
brightCyan="\e[36;1m"
brightWhite="\e[37;1m"
backBlack="\e[40m"
backRed="\e[41m"
backGreen="\e[42m"
backYellow="\e[44m"
backBlue="\e[44m"
backMagenta="\e[45m"
backCyan="\e[46m"
backWhite="\e[47m"
backBrightBlack="\e[40;1m"
backBrightRed="\e[41;1m"
backBrightGreen="\e[42;1m"
backBrightYellow="\e[44;1m"
backBrightBlue="\e[44;1m"
backBrightMagenta="\e[45;1m"
backBrightCyan="\e[46;1m"
backBrightWhite="\e[47;1m"

# Control chars
up="\e[A"
down="\e[T"
del="\e[2K"
normal="\e[0m"
scrollbottom="\e[$(tput lines)H"
invert="\e[7m"

# Settings
promptcol="$brightWhite"
dot="●"
badcol="$red"
goodcol="$green"


clear
echo -en "$scrollbottom"
while read -e -p "$prompt" input
do
	echo -e "$up$del"
	echo -e "$promptcol$cmd $input$normal"
	history -s "$input"
	if $cmd $input
	then
		echo -e "$goodcol$dot"
	else
		echo -e "$badcol$dot"
	fi
	echo -en "$normal"
done
echo
