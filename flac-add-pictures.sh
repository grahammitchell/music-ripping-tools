#!/bin/bash

# 2012-02-09
# Embed cover-small.jpg into all FLACS in current directory,
#   unless: cover.jpg doesn't exist, or the FLAC already has cover art embedded.

coverart=$( metaflac --list --block-type=PICTURE *.flac )
if [ -n "$coverart" ]; then
	echo "Cover art already embedded. Aborting."
	exit 2;
fi

if [ ! -e cover.jpg ]; then
	echo "'cover.jpg' not found. Aborting."
	exit 1;
fi

if [ ! -e cover-small.jpg ]; then
	echo "Converting 'cover.jpg' to 'cover-small.jpg'"
	convert cover.jpg -filter cubic -resize 250x250! -unsharp 0x1 cover-small.jpg
fi

if [ ! -e cover-small.jpg ]; then
	echo "'cover-small.jpg' not found. Aborting."
	exit 3;
fi

echo Adding \(small\) cover art to FLACs
metaflac --import-picture-from=cover-small.jpg *.flac
