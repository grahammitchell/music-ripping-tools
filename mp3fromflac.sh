#!/usr/bin/env bash

BITRATE0="-h -V0"
BITRATE1="--preset extreme"
BITRATE2="-V2"

BITRATE=$BITRATE2

OPTS="--replaygain-accurate --nohist"

path=`dirname $0`

for i in *.flac
do
	foo=`basename "$i" .flac`
	metaflac --export-tags-to="$foo.txt" --no-utf8-convert "$i"
	flac -d "$i"
	echo "lame $OPTS $BITRATE `$path/txt2lame_opt.pl \"$foo.txt\"` \"$foo.wav\" \"$foo.mp3\"" > "$foo.sh"
	sh "$foo.sh"
	if [ -e cover-small.jpg ]; then
		eyeD3 --add-image cover-small.jpg:FRONT_COVER "$foo.mp3"
	elif [ -e cover.jpg ]; then
		eyeD3 --add-image cover.jpg:FRONT_COVER "$foo.mp3"
	fi
	rm "$foo.txt"
	rm "$foo.wav"
	rm "$foo.sh"
done
