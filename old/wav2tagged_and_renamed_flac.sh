#!/usr/bin/env bash

if [ ! -e track_info.txt ]
then
	echo "'track_info.txt' not found.  Aborting."
	exit 1
fi

flac --delete-input-file --replay-gain *.wav

artist=`head -1 track_info.txt`
album=`head -2 track_info.txt | tail -1`
date=`head -3 track_info.txt | tail -1`
n=4
track=1

for i in *.flac
do
	foo=`basename $i .flac`
	metaflac --export-tags-to=${foo}_out.txt --no-utf8-convert $i
	echo "ARTIST=$artist" > ${foo}_in.txt
	echo "ALBUM=$album" >> ${foo}_in.txt
	title=`head -$n track_info.txt | tail -1`
	n=$(( $n + 1 ))
	echo "TITLE=$title" >> ${foo}_in.txt
	echo "DATE=$date" >> ${foo}_in.txt
	if [ $track -lt "10" ]
	then
		trackno=0$track
	else
		trackno=$track
	fi
	echo "TRACKNUMBER=$trackno" >> ${foo}_in.txt
	track=$(( $track + 1 ))
	cat ${foo}_out.txt >> ${foo}_in.txt
	metaflac --remove-all-tags --no-utf8-convert --import-tags-from=${foo}_in.txt $i
	rm ${foo}_out.txt ${foo}_in.txt
	name=`echo "$title" | tr " " "_"`.flac
	echo $name >> full_album.m3u
	mv $i $name
done
