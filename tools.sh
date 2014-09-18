#!/bin/bash
# __func will automatically be used to complete func. It should output a list of
# all possible arguments against which the users partial input can be matched.


################################################################################
# cdgo PACKAGE  -  shortcut to go sources on github
################################################################################
godir="$HOME/go/src/github.com/luksen/"
function cdgo() { cd $godir/$1; }
function __cdgo() { ls -Q $godir; }


################################################################################
# note NOTEBOOK  -  note taking
################################################################################
notedir="$HOME/notes/"
function note() {
	if [ -z $1 ]
	then
		vim "$notedir/misc.mkdn"
	else
		vim "$notedir/${1}.mkdn"
	fi
	d=$(pwd)
	cd $notedir
	git up
	cd $d
}
function __note() {
	notes=$(ls -t -Q $notedir -I archiv -I config.sh -I notes.vim)
	echo "${notes[@]//.mkdn/}"
}


################################################################################
# big DIR  -  helper for cleaning up
################################################################################
function big() {
	echo -e "size\tlast modified\t\tfile"
	echo -e "‾‾‾‾\t‾‾‾‾‾‾‾‾‾‾‾‾‾\t\t‾‾‾‾"
	find "$@" -mindepth 1 -maxdepth 1 -true -exec bash -c 'eval du -sh --time {} 2>/dev/null' ';' | sed 's/\.\///' | sort -h | tail
}


################################################################################
# shosho SHOW  -  completion for shosho
################################################################################
function __shosho() {
	cat sho.csv | cut -d, -f1 | sed 's/^.*$/"&"/'
}


################################################################################
# delknown IPTAIL  -  delete a known ssh host
################################################################################
function delknown() {
	sed -i -r "/192\.168\...?.?\.$1/d" ~/.ssh/known_hosts 
}
function __delknown() {
	grep  -o -E '192\.168\...?.?\...?.? ' ~/.ssh/known_hosts | cut -d. -f4
}


################################################################################
# pmount DEVICE  -  rudimentary tab completion for pmount
################################################################################
function __pmount() {
	ls -Q /dev/ | grep sd[b-z][0-9]
}


################################################################################
# _func_complete  -  plumbing for simple completion
################################################################################
# Generates a completion function for the first argument and plugs it in. The
# generated function requires a function with the same name as the first
# argument, but two preceding underscores. This function should require no
# arguments and return a list of all possible arguments to the original
# function.
function _func_complete() {
	eval "function _generated_$1() { COMPREPLY=( \$(compgen -W \"\$(__$1)\" \"\$2\") ); }"
	complete -F "_generated_$1" "$1"
}
# Runs _func_complete for all functions that have a corresponding double
# underscore function.
while read func
do
	_func_complete $func
done < <( 
grep -o 'function __.\+()' ~/tools/tools.sh |
sed 's/.*__//' |
sed 's/()//' )
