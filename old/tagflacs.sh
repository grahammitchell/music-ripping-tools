#!/usr/bin/env bash

artist=`head -1 track_info.txt`
album=`head -2 track_info.txt | tail -1`
date=`head -3 track_info.txt | tail -1`
n=4
track=1

for i in *.flac
do
	foo=`basename $i .flac`
	metaflac --export-vc-to=${foo}_out.txt --no-utf8-convert $i
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
	metaflac --remove-vc-all --no-utf8-convert --import-vc-from=${foo}_in.txt $i
	rm ${foo}_out.txt ${foo}_in.txt
	name=`echo "$title" | tr " " "_"`.flac
	echo $name >> full_album.m3u
	mv $i $name
done
