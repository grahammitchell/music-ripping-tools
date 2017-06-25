#!/bin/bash

# Makes current directory of FLACs into oggs for my phone

# 2012-06-28 - initial version whittled from voter.sh (itself dating from Jan 2009)

destdir="/media/6EA7-08E1/Music/oggs"
#destdir="/media/=>0Q/Music/oggs"
tempdir="ogg-q6"

declare -a phones=('=>0Q', '6EA7-08E1', 'deannas')

curdir=$( pwd )
foldername=$( basename "$curdir" | awk '{ \
	gsub(/ /, "-", $0) ; \
	gsub(/_/, "-", $0) ; \
	gsub(/:/, "", $0) ; \
	gsub(/,/, "", $0) ; \
	gsub(/\.\.\./, "", $0) ; \
	gsub(/\?/, "", $0) ; \
	gsub(/--/, "-", $0) ; \
	gsub(/-$/, "", $0) ; \
	gsub(/^the-/, "", $0) ; \
	gsub(/^a-/, "", $0) ; \
	printf("%s", tolower($0)) \
}' )

need_cleaning=$( grep EXTINF full_album.m3u )
if [ -n "$need_cleaning" ]; then
	echo -n "Cleaning 'full_album.m3u'... "
	/home/mitchell/code/ripping/clean_m3u.rb
	echo "done."
fi

first_track=$( head -1 full_album.m3u )

need_totaltracks=$( metaflac --show-tag=TOTALTRACKS "$first_track" )
if [ -z "$need_totaltracks" ]; then
	count=$( wc -l full_album.m3u | cut --delim=' ' -f 1 )
	printf -v count00 "%02d" $count
	metaflac --set-tag=TOTALTRACKS=$count00 *.flac
	/home/mitchell/code/ripping/tagsort.rb
fi

need_replaygain=$( metaflac --show-tag=REPLAYGAIN_REFERENCE_LOUDNESS "$first_track" )
if [ -z "$need_replaygain" ]; then
	echo -n "Adding/fixing replay gain in FLACs... "
	metaflac --add-replay-gain *.flac
	echo "done."
fi

if [ ! -d "$tempdir" ]; then
	mkdir $tempdir
else
	echo "    $tempdir already exists."
fi

for i in *.flac
do
	filename=$( basename $i ".flac" )
	filename=${filename//\?/} # remove invalid characters (form is ${string//pattern/replacement})
	oggfile=${filename}'.ogg'
	if [ -e $tempdir/$oggfile ]; then echo "    $oggfile exists - encoding skipped."
	else
		echo -n "    $oggfile encoding... "
		oggenc -Q -q 6 $i -o $tempdir/$oggfile
		echo "done."
	fi
done

if [ ! -e "$tempdir/cover.jpg" ]; then
	ln cover.jpg $tempdir
fi

if [ "$1" != "--keep" ]; then
	if [ -d "$destdir" ]; then
		echo -n "    Copying files to $destdir/$foldername..."
		cp -R $tempdir "$destdir/$foldername"
		echo " done."
		cd "$destdir/$foldername"
		/home/mitchell/code/ripping/number_oggs.sh
		cd "$curdir"
	else
		echo "Can't find '$destdir'; is the phone plugged in?"
		exit 1
	fi
fi

echo "All done."
