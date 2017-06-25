#!/bin/bash

# Undo some of the what.cd-specific stuff in a folder full of FLACs

# mkdir what.cd
# mv *.cue *.log *.m3u what.cd

if [ -e folder.jpg ]; then
	mv folder.jpg cover.jpg
fi

replay=$( metaflac --show-tag=REPLAYGAIN_TRACK_GAIN 01*.flac )
if [ -z "$replay" ]; then
	echo Adding replay gain to FLACs
	metaflac --add-replay-gain *.flac
fi

if [ ! -e track_info.txt ]; then
	echo Building track_info.txt and full_album.m3u
	metaflac --show-tag=ARTIST 01*.flac | cut -b 8- >> track_info.txt
	metaflac --show-tag=ALBUM 01*.flac | cut -b 7- >> track_info.txt
	metaflac --show-tag=DATE 01*.flac | cut -b 6- >> track_info.txt

	for i in *.flac
	do
		tracktitle=$( metaflac --show-tag=TITLE "$i" | cut -b 7- )
		flacname=$( echo $tracktitle | awk '{ \
			gsub(/ /, "_", $0) ; \
			printf("%s.flac", $0) \
		}' )
		echo $tracktitle >> track_info.txt
		echo $flacname >> full_album.m3u
	done
fi

# metaflac --remove-tag=DATE *.flac
# /home/mitchell/bin/ren-regexp.pl "s/^\d\d - //" "s/ /_/g" *.flac

rename 's/ /_/g' *.flac

if [ ! -f name-foo ]; then
	pwd | tr '/' '\n' | tail -2 > name-foo
fi

# rmdir --ignore-fail-on-non-empty what.cd
truncate -s 0 full_album.m3u
