#!/bin/bash
set -u
IFS="$(printf '\n\t')"

# Rename album folders to have release year prepended.

# 2016-07-23 - initial version

for folder in * ; do
	if [ -f $folder/track_info.txt ]; then
		year=$( head -3 $folder/track_info.txt | tail -1 | cut -b 1-4 )
		dest="$year""-""$folder"
		mv $folder $dest
	fi
done
