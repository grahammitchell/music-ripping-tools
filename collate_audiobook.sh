#!/bin/bash

for i in disc*
do
	cd $i
	mv *.flac .. &&	rm track_info.txt && rm full_album.m3u
	cd ..
	rmdir --ignore-fail-on-non-empty $i
done
