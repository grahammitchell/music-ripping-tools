#!/usr/bin/env bash

if [ ! -d "16000" ]
then
	mkdir 16000
fi

for i in *.flac
do
	foo=`basename $i .flac`
	flac -d $i
	sox -V $foo.wav -r 16000 -c 1 $foo-16000.wav resample
	rm $foo.wav
	mv $foo-16000.wav 16000/$foo.wav
done
play /usr/share/sounds/KDE_Beep_Bottles.wav
