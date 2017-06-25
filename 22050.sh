#!/usr/bin/env bash

if [ ! -d "22050" ]
then
	mkdir 22050
fi

for i in *.flac
do
	foo=`basename $i .flac`
	metaflac --export-vc-to=$foo.txt --no-utf8-convert $i
	flac -d $i
	sox -V $foo.wav -r 22050 $foo-22050.wav resample
	flac $foo-22050.wav
	metaflac --remove-vc-all --no-utf8-convert --import-vc-from=$foo.txt $foo-22050.flac
	rm $foo.wav $foo-22050.wav $foo.txt
	mv $foo-22050.flac 22050/$foo.flac
done
play /usr/share/sounds/KDE_Beep_Bottles.wav
