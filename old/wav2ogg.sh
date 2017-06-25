#!/usr/bin/env bash

for i in *.flac
do
	q=5
	foo=`basename $i .flac`
	metaflac --export-vc-to=$foo.txt --no-utf8-convert $i
	if [ ! -z "$1" ]
	then
		q=$1
	fi
	oggenc -q $q $foo.wav
	vorbiscomment -w $foo.ogg -c $foo.txt
	rm $foo.txt
	# play /usr/share/sounds/KDE_Beep_ShortBeep.wav
done
play /usr/share/sounds/KDE_Beep_Bottles.wav
