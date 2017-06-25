#!/bin/bash
set -u
IFS="$(printf '\n\t')"

# Convert playlist with FLAC extensions to .ogg

# 2012-11-15 - initial version

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

# check for full_album, since we gots to have that
if [ ! -f full_album.m3u ]; then
	echo "ERROR: File not found: $curdir/full_album.m3u"
	exit 1
fi

first_track=$( head -1 full_album.m3u )

# make sure full_album ends in .ogg instead of .flac
flac_playlist=0
extension="${first_track##*.}"
if [ "$extension" != "ogg" ]; then
	flac_playlist=1
fi

# Convert FLAC playlist to ogg playlist
if [ $flac_playlist -eq 1 ]; then
	echo -n "Fixing $curdir/full_album.m3u from flac => ogg... "
	awk '{ sub(/.flac$/, ".ogg"); print }' full_album.m3u > full_album.tmp && mv full_album.tmp full_album.m3u
	echo "done."
fi

exit 0

