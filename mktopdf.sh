#!/bin/bash

tmpfile=mktopdftmp.html

[ $# -eq 2 ] || exit 1

style="$(dirname $0)/data/style.css"
[ -f style.css ] && style=style.css

markdown $1 | recode -d utf8..html > $tmpfile 
wkhtmltopdf --user-style-sheet $style $tmpfile $2
rm $tmpfile
