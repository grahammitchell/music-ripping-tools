#!/bin/bash

# Undo some of the abcde-specific stuff in a folder full of FLACs
# 2012-03-23

if [ -d "$1" ]
then
	src="$1"
	echo Moving FLACs from $src
	src=${src%/}
	mv $src/* . && rmdir $src
fi

replay=$( metaflac --show-tag=REPLAYGAIN_TRACK_GAIN 01*.flac )
if [ -z "$replay" ]; then
	echo Adding replay gain to FLACs
	metaflac --add-replay-gain *.flac
fi

if [ ! -e track_info.txt ]; then
	echo Building track_info.txt
	metaflac --show-tag=ARTIST 01*.flac | cut -b 8- >> track_info.txt
	metaflac --show-tag=ALBUM 01*.flac | cut -b 7- >> track_info.txt
	if [ -e date.txt ]; then
		cat date.txt >> track_info.txt
		rm date.txt
	else
		metaflac --show-tag=DATE 01*.flac | cut -b 6- >> track_info.txt
	fi

	for i in *.flac
	do
		tracktitle=$( metaflac --show-tag=TITLE "$i" | cut -b 7- )
		echo $tracktitle >> track_info.txt
	done
fi

fulldate=$( head -3 track_info.txt | tail -1 )
fulldate="${fulldate%\\n}"

cur_date=$( metaflac --show-tag=DATE 01*.flac | cut -b 6- )
if [ ${#cur_date} -lt ${#fulldate} ]; then
	echo -n $cur_date is shorter than $fulldate, fixing...
	metaflac --remove-tag=DATE *.flac
	metaflac --set-tag=DATE=$fulldate *.flac
	/home/mitchell/code/ripping/tagsort.rb
	echo " done."
fi

echo "You should check the capitalization and such in track_info.txt now."
echo "Then execute /home/mitchell/code/ripping/wav2tagged_and_renamed_flac.rb"
