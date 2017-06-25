#!/bin/bash

# Makes current directory of FLACs into zipfile containing oggs and other files for voter.

# 2009-01-17 - initial version, learned a bit about awk
# 2012-02-23 - added auto-cleaning of .m3u, adding of replaygain / TOTALTRACKS tags, and --move argument
# 2012-04-10 - inverted --move to --keep

curdir=$( pwd )
zipname=$( basename "$curdir" | awk '{ \
	gsub(/ /, "-", $0) ; \
	gsub(/_/, "-", $0) ; \
	gsub(/:/, "", $0) ; \
	gsub(/,/, "", $0) ; \
	gsub(/\?/, "", $0) ; \
	gsub(/--/, "-", $0) ; \
	gsub(/-$/, "", $0) ; \
	gsub(/^the-/, "", $0) ; \
	gsub(/^a-/, "", $0) ; \
	printf("%s.zip", tolower($0)) \
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

for i in *.flac
do
	filename=$( basename $i ".flac" )
	oggfile=${filename}'.ogg'
	if [ -e $oggfile ]; then echo "$oggfile exists - encoding skipped."
	else
		echo -n "    $oggfile encoding... "
		oggenc -Q -q 6 $i
		echo "done."
	fi
done

if [ ! -f name-foo ]; then
	pwd | tr '/' '\n' | tail -2 > name-foo
fi

mkdir -p voter-temp
cd voter-temp

if [ -e ../hits.txt ]; then ln -f ../hits.txt  . ; fi
if [ -e ../album.m3u ]; then ln -f ../album.m3u . ; fi
if [ -e ../lyrics.txt ]; then ln -f ../lyrics.txt . ; fi

ln -f ../cover.jpg .
ln -f ../full_album.m3u .
ln -f ../name-foo .
ln -f ../track_info.txt .
ln -f ../*.ogg .

if [ -e $zipname ]; then rm -f $zipname ; fi
zip -0oq $zipname * && echo "$zipname created."
ln -f $zipname ..
cd ..

if [ "$1" != "--keep" ]; then
	echo -n "    Moving zipfile to ~/Dropbox..."
	mv -i $zipname /home/mitchell/Dropbox/
	echo " done."
fi

rm -Rf voter-temp && rm -f *.ogg && echo "All done."
