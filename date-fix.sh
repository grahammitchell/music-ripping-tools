#!/bin/bash

# Replace missing DATE tag (or only 4 digits) with full date from track_info.txt.

# 2012-02-23 - initial version

need_cleaning=$( grep EXTINF full_album.m3u )
if [ -n "$need_cleaning" ]; then
	echo -n "Cleaning 'full_album.m3u'... "
	/home/mitchell/code/ripping/clean_m3u.rb
	echo "done."
fi

first_track=$( head -1 full_album.m3u )

fulldate=$( head -3 track_info.txt | tail -1 )

# chomp date - ${STRING%SUBSTRING} removes SUBSTRING from the end of STRING; also escape the \
fulldate="${fulldate%\\n}"

cur_date=$( metaflac --show-tag=DATE "$first_track" | cut -b 6- )
if [ ${#cur_date} -lt ${#fulldate} ]; then
	echo -n $cur_date is shorter than $fulldate, fixing...
	metaflac --remove-tag=DATE *.flac
	metaflac --set-tag=DATE=$fulldate *.flac
	/home/mitchell/code/ripping/tagsort.rb
	echo " done."
fi
