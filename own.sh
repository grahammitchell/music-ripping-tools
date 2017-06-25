#!/bin/sh

path=`dirname $0`

if [ -s tracks ]
then
	$path/stripcr.sh tracks
	$path/rename.pl
fi

if [ ! -s full_album.m3u ]
then
	cp album.m3u full_album.m3u
fi

chown root.mp3users .
chown root.mp3users ../.
chown root.mp3users *
chmod 750 .
chmod 750 ../.
chmod 640 *
$path/mk_html.pl
ls -l
