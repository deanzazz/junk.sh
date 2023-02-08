#!/bin/bash
#Dean Zazzera
#I pledge my honor that I have abided by the Stevens Honor System. DZ


h=0
l=0
p=0

readonly junkdir=~/.junk

function printuse {
	cat << EOF
Usage: $(basename "$0") [-hlp] [list of files]
   -h: Display help.
   -l: List junked files.
   -p: Purge all files.
   [list of files] with no other arguments to junk those files.
EOF
}


usg="Usage: junk.sh [-hlp] [list of files]"

while getopts ":hlp" option; do 
	case ${option} in
	h)
		h=1 ;;
	l)
		l=1 ;;
	p) 
		p=1 ;;
	*)
		echo "Error: Unknown option '-$OPTARG'". >&2
		printuse
		exit 1
	esac
done

if [[ ($h -eq 1 && $l -eq 1) || ($h -eq 1 && $p -eq 1) || ($l -eq 1 && $p -eq 1) || ($h -eq 1 && $l -eq 1 && $p -eq 1) ]]; then
	echo Error: Too many options enabled. >&2
	printuse
	exit 1
fi

for var2 in "$@"
do
if [[ (!($h -eq 0) || !($l -eq 0) || !($p -eq 0)) && $var2 != -* ]]; then
	echo Error: Too many options enabled. >&2
	printuse
	exit 1
fi
done

if [[ $h -eq 1 ]]; then
	printuse
	exit 0
fi

if [[ $# -eq 0 ]]; then
	printuse
	exit 0
fi

if [[ -d $junkdir ]]; then
	:
else
	mkdir $junkdir
fi

#done parsing

if [[ $l -eq 1 ]]; then
	ls $junkdir -lAF
	exit 0
fi

if [[ $p -eq 1 ]]; then
	if [[ -z "$(ls -A $junkdir)" ]]; then
		exit 0
	else
		readonly junkcontents=$(ls -A $junkdir)
		for vari in $junkcontents
		do
			rm -r $junkdir/$vari
		done
		exit 0
	fi
fi

for var in "$@"
do
if [[ -e $var ]]; then
	mv $var $junkdir
else 
	echo "Warning: '$var' not found." >&2
fi
done








