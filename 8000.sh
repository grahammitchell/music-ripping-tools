#!/usr/bin/env bash

if [ ! -d "8000" ]
then
	mkdir 8000
fi

for i in *.flac
do
	foo=`basename $i .flac`
	flac -d $i
	sox -V $foo.wav -r 8000 -c 1 $foo-8000.wav resample
	rm $foo.wav
	mv $foo-8000.wav 8000/$foo.wav
	speexenc -n 8000/$foo.wav 8000/$foo.spx
done
play /usr/share/sounds/KDE_Beep_Bottles.wav
