#!/usr/bin/env bash

for i in *.flac
do

	if [ ! -z "$2" ]
	then
		foo=`basename $i $2.flac`
	else
		foo=`basename $i .flac`
	fi

	if [ -z "$1" ]
	then
		path=.
	else
		path=$1
	fi
	ogg=$path/$foo.ogg

	if [ ! -e "$ogg" ]
	then
		echo "Skipping \"$i\", corresponding ogg not found."
	else
		echo -n "Tagging \"$i\"..."
		vorbiscomment -l $ogg > $foo.txt
		metaflac --remove-vc-all --no-utf8-convert --import-vc-from=$foo.txt $i
		rm $foo.txt
		echo done.
	fi
	# play /usr/share/sounds/KDE_Beep_ShortBeep.wav
done
play /usr/share/sounds/KDE_Beep_Bottles.wav
