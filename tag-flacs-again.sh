#!/bin/bash
set -u
IFS="$(printf '\n\t')"

# Retag everything from track_info.txt because something is screwed up.

# 2012-11-27 - initial version

/home/mitchell/code/ripping/number_flacs.sh

truncate -s 0 full_album.m3u

/home/mitchell/code/ripping/wav2tagged_and_renamed_flac.rb

touch "force-voter"

/home/mitchell/code/ripping/voter2.sh

rm "force-voter"

exit 0
