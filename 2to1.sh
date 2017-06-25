#!/bin/sh

# 2to1.sh  - 5 January 2002

# Turn a double album in ALBUM_1 and ALBUM_2 into ALBUM/Disc_1 and
# ALBUM/Disc_2, with hard links to all tracks from both albums in ALBUM/ and
# with a single combined playlist.

# Invoke from the directory containing ALBUM_1 and ALBUM_2, and pass it a
# parameter of "ALBUM" (i.e. without the _1 or a trailing slash or anything).

if [ ! -z "$1" ]
then
	mkdir $1/
	mv $1_1 $1/Disc_1
	mv $1_2 $1/Disc_2
	cd $1/
fi

# If invoked without any parameters, it's assumed the above is already done
# and you just want the links and playlist.

ln Disc_1/*.ogg .
ln Disc_2/*.ogg .
cat Disc_1/album.m3u Disc_2/album.m3u > album.m3u
cat Disc_1/full_album.m3u Disc_2/full_album.m3u > full_album.m3u
if [ -s Disc_1/lyrics.txt ]
then
	cat Disc1/lyrics.txt > lyrics.txt
fi
if [ -s Disc_2/lyrics.txt ]
then
	cat Disc2/lyrics.txt >> lyrics.txt
fi
chown root.music album.m3u full_album.m3u lyrics.txt
chmod 640 album.m3u full_album.m3u lyrics.txt
touch Disc_1/.ignoreme
touch Disc_2/.ignoreme
