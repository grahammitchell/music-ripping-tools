#!/bin/bash
set -u
IFS="$(printf '\n\t')"

# Recreate full_album.m3u from tagged FLACs, since I accidentally truncated them all.

# 2012-11-14 - initial version

# work in folder provided if present
if [[ $# != 0 && -d "$1" ]]
then
	cd "$1"
	if [ $? -gt 0 ]; then
		echo "ERROR: Can't cd into $1"
		exit 1
	fi
fi

curdir=$( pwd )

if [[ -e full_album.m3u && -s full_album.m3u ]]
then
	echo "  IGNORE non-zero playlist: $curdir/full_album.m3u"
	exit 0
fi

truncate -s 0 full_album.tmp

for f in *.flac
do
	trackno=$( metaflac --show-tag=TRACKNUMBER "$f" | cut -d= -f2 )
	if [ -z "$trackno" ]; then
		echo "  ERROR missing tracknumber: $curdir/$f"
		rm full_album.tmp
		exit 1
	fi
	discno=$( metaflac --show-tag=DISCNUMBER "$f" | cut -d= -f2 )
	if [ -z "$discno" ]; then
		discno="00"
	fi
	printf "%s%s\t%s\n" $discno $trackno "$f" >> full_album.tmp
done

sort -n full_album.tmp | cut -f2 > full_album.tmp.sorted
cat full_album.tmp.sorted > full_album.m3u
rm full_album.tmp full_album.tmp.sorted

# remove empty album.m3u, if present
if [[ -e album.m3u && ! -s album.m3u ]]
then
	rm album.m3u
fi

exit 0

