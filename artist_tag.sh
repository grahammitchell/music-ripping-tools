#!/bin/bash
set -u
IFS="$(printf '\n\t')"

# Tag a bunch of FLACs with the artists in artists.txt

# 2012-11-14 - initial version

curdir=$( pwd )

if [ ! -e artists.txt ]
then
	echo "  ERROR file not found: $curdir/artists.txt"
	exit 1
fi

# populate array from file. This only works if spaces aren't in IFS
i=0
for a in $( cat artists.txt )
do
	artists[$i]="$a"
	i=$(( $i + 1 ))
done

i=0
for f in $( cat full_album.m3u )
do
	a=${artists[$i]}
	metaflac --remove-tag=ARTIST "$f"
	metaflac --set-tag=ARTIST="$a" "$f"
	i=$(( $i + 1 ))
done

/home/mitchell/code/ripping/tagsort.rb

exit 0

