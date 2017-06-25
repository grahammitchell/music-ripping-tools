#!/bin/bash
set -u
IFS="$(printf '\n\t')"

# Makes current directory of FLACs into folder containing oggs and other files for voter.

# 2012-10-25 - initial version whittled from voter.sh
# 2012-11-15 - removed broken FLAC to ogg playlist code
# 2012-11-27 - added force-voter option
# 2015-04-07 - ogg quality is now a parameter
# 2017-03-28 - fixed FLAC to ogg playlist. Thanks, sed!

quality="q6"
destbase="/data/voter-oggs"
tempdir="ogg-""$quality"

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

function count_oggs() {
	# give count of files ending in .ogg in the current working directory
	local wd='.'
	if [[ $# != 0 && -d "$1" ]]
	then
		wd="$1"
	fi

	local count=$( find "$wd" -maxdepth 1 -type f -name '*.ogg' | wc -l )

	return $count
}

# check for full_album, since we gots to have that
if [ ! -f full_album.m3u ]; then
	echo "ERROR: File not found: $curdir/full_album.m3u"
	exit 1
fi

# ditto for name-foo, so we know where to store things
if [ ! -f name-foo ]; then
	pwd | tr '/' '\n' | tail -2 > name-foo
fi

# get destination folders
artistfolder=$( head -1 name-foo )
albumfolder=$( tail -1 name-foo )

destfolder=$destbase/$artistfolder/$albumfolder

need_cleaning=$( grep EXTINF full_album.m3u )
if [ -n "$need_cleaning" ]; then
	echo -n "Cleaning 'full_album.m3u'... "
	/home/mitchell/code/ripping/clean_m3u.rb
	echo "done."
fi

first_track=$( head -1 full_album.m3u )

# make sure first_track ends in .flac instead of .ogg
extension="${first_track##*.}"
if [ "$extension" != "flac" ]; then
	first_track="${first_track%.*}"".flac"
fi

num_wanted=$( cat full_album.m3u | wc -l )

flac_count=$( find . -maxdepth 1 -type f -name '*.flac' | wc -l )
ogg_count=$( find . -maxdepth 1 -type f -name '*.'$extension | wc -l )

if [ $flac_count -lt $num_wanted ]; then
	if [ $ogg_count -ge $num_wanted ]; then
		echo "ERROR: ${extension}s instead of FLACs in $curdir"
	else
		echo "ERROR: Not enough FLAC files found for $curdir/full_album.m3u"
	fi
	exit 1
fi

need_totaltracks=$( metaflac --show-tag=TOTALTRACKS "$first_track" )
if [ -z "$need_totaltracks" ]; then
	# echo -n "Adding TOTALTRACKS tag to FLACs... "
	printf -v count00 "%02d" $num_wanted
	metaflac --set-tag=TOTALTRACKS=$count00 *.flac
	/home/mitchell/code/ripping/tagsort.rb
	# echo "done."
fi

need_replaygain=$( metaflac --show-tag=REPLAYGAIN_REFERENCE_LOUDNESS "$first_track" )
if [ -z "$need_replaygain" ]; then
	echo -n "Adding/fixing replay gain in FLACs... "
	metaflac --add-replay-gain *.flac
	echo "done."
fi

#see if we've already encoded into this folder
count_oggs $tempdir
cur_oggs=$?

#see if we've already encoded into destination folder
count_oggs $destfolder
dest_oggs=$?

total_oggs=$(( $cur_oggs + $dest_oggs ))

need_to_encode=1
need_to_copy=1
if [ $total_oggs -eq 0 ]; then
	# echo "No oggs anywhere! Need to encode!"
	:
elif [ $dest_oggs -ge $num_wanted ]; then
	# echo "Nothing to do."
	need_to_encode=0
	need_to_copy=0
elif [ $cur_oggs -ge $num_wanted ]; then
	# echo "Temp folder already has enough files. Copying but no encoding needed."
	need_to_encode=0
else
	echo "Not sure what needs to be done in $curdir - $num_wanted wanted, have $cur_oggs"
fi

if [ -f "force-voter" ]; then
	need_to_encode=1
	need_to_copy=1
fi

# actually encode them
if [ $need_to_encode -eq 1 ]; then
	mkdir -p ./$tempdir

	echo -n "Transcoding FLACs in $curdir to ogg... "
	find . -maxdepth 1 -type f -name '*.flac' -print0 | xargs -0 -n 2 -P 6 oggenc -Q -$quality
	echo "done."

	# Move oggs
	mv *.ogg ./$tempdir
fi

# Link cover art
if [ -e cover.jpg ]; then
	ln -f cover.jpg ./$tempdir
else
	echo "WARNING: cover.jpg doesn't exist in $curdir"
fi

# Copy the playlist, swapping flac for ogg
sed 's/.flac$/.ogg/' <full_album.m3u > ./$tempdir/full_album.m3u

declare -a files=('name-foo' 'album.m3u' 'track_info.txt' 'lyrics.txt' 'hits.txt');

# Link the rest of the files
for f in "${files[@]}"
do
	if [ -e "$f" ]
	then
		ln -f $f ./$tempdir
	fi
done

# Copy everything to destination folder
if [ $need_to_copy -eq 1 ]; then
	mkdir -p $destfolder

	echo -n "Copying files into $destfolder... "
	cp -a ./$tempdir/* $destfolder/
	echo "done."
fi

exit 0

