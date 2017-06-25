#!/bin/sh

if [ ! -z "$1" ]
then

	rm -f *.mp3 full_album.m3u

	if [ -s tracks ]
	then
		rm -f album.m3u
		mv tracks /home/music/$1
	else
		echo Warning: no \"tracks\", you\'ll need to modify album.m3u.
	fi

	dirname `pwd` | cut -b 8- > name-foo
	basename `pwd` >> name-foo

	mv name-foo /home/music/$1

else
	echo You must supply a directory to move things to.
fi
