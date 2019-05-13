#!/bin/bash
set -u
IFS="$(printf '\n\t')"

# Rename album folders to have release year prepended.

# 2016-07-23 - initial version
# 2017-08-29 - skip folders for which this has already been done

for folder in * ; do
	already_done=$( echo "$folder" | grep "^[12][90][0-9][0-9]-.*" )
	if [ ! "$already_done" ] && [ -f $folder/track_info.txt ]; then
		year=$( head -3 $folder/track_info.txt | tail -1 | cut -b 1-4 )
		dest="$year""-""$folder"
		mv $folder $dest
	fi
done
