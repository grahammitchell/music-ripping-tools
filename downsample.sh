#!/usr/bin/env bash

for i in *.wav
do
	foo=`basename $i .wav`
	echo -n Downsampling $i to $foo-22050.wav...
	sox $i -r 22050 $foo-22050.wav resample
	echo done.
done
play /usr/share/sounds/KDE_Beep_Bottles.wav
