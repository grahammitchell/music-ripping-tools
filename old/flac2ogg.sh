#!/usr/bin/env bash

~mitchell/code/ripping/clean_m3u.rb

for i in *.flac
do
	foo=`basename $i .flac`
	metaflac --export-tags-to=$foo.txt --no-utf8-convert $i
	if [ ! -z "$1" ]
	then
		echo "DATE=$1" >> $foo.txt
	fi
	flac -d $i
	normalize-audio $foo.wav
	oggenc -q 5 $foo.wav
	rm $foo.wav
	vorbiscomment -w $foo.ogg -c $foo.txt
	rm $foo.txt
	# play /usr/share/sounds/KDE_Beep_ShortBeep.wav
done
play /usr/share/sounds/KDE_Beep_Bottles.wav
