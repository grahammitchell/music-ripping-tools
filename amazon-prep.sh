#!/bin/bash

if [ ! -d mp3s ]; then
	mkdir mp3s
fi

ln *.flac mp3s

if [ ! -e cover-small.jpg ]; then
	echo "Converting 'cover.jpg' to 'cover-small.jpg'"
	convert cover.jpg -filter cubic -resize 250x250! -unsharp 0x1 cover-small.jpg
fi

if [ -e cover-small.jpg ]; then
	ln cover-small.jpg mp3s
elif [ -e cover.jpg ]; then
	ln cover.jpg mp3s
fi

cd mp3s || exit

/home/mitchell/code/ripping/mp3fromflac.sh

/home/mitchell/code/ripping/number_mp3s.sh

rm *.flac *.jpg

#echo "Mine." > from-flac.txt
ls
cd ..
