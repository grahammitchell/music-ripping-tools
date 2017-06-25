#!/bin/bash

file="$1"
fileOut="${file%.flac}.m4a"
result=0

if [ -f "$fileOut" ]; then
	echo Already exists: "$fileOut"
	exit
else
	# Transcode from flac to aac
	flac -c -d "$file" - | neroAacEnc -if - -q 0.7 -of "$fileOut" >/dev/null 2>&1
	result=$?
	if [ $result -eq 0 ]; then
		echo Transcoded: "$file"
	else
		echo Error code $result on "$file"
		exit
	fi
fi

mungeTag()
{
	# Converts tags created by Banshee in flac to those expected by neroAacTag
	case "$tagName" in
		"DATE") tagName="year"; tagValue=${tagValue:0:4};;
		"TRACKNUMBER") tagName="track";;
		"TRACKTOTAL") tagName="totaltracks";;
		"DISCNUMBER") tagName="disc";;
		"DISCTOTAL") tagName="totaldiscs";;
		"ALBUM ARTIST" | "ALBUMARTIST" | "COMMENT") tagName="SKIP";;
		*) tagName=`echo "$tagName" | tr '[:upper:]' '[:lower:]'`;;
	esac
}

# Copy the tags from source to destination file
IFS=$'\012' # separate on newlines, ignoring spaces
tags=`metaflac "$file" --export-tags-to=-`
count=0
for tag in $tags; do
	tagName=`echo "$tag" | cut -d "=" -f 1`
	tagValue=`echo "$tag" | cut -d "=" -f 2`
	mungeTag
	#echo $tagName="$tagValue"
	if [ "$tagName" != "SKIP" ]; then
		neroAacTag "$fileOut" -meta-user:"$tagName"="$tagValue" >/dev/null 2>&1
		((count++))
	fi
done

echo $count tags written

# Also do the album art, if present

if [ -e cover-small.jpg ]; then
	neroAacTag "$fileOut" -add-cover:front:cover-small.jpg >/dev/null 2>&1
	echo Added front cover \'cover-small.jpg\'
elif [ -e cover.jpg ]; then
	neroAacTag "$fileOut" -add-cover:front:cover.jpg >/dev/null 2>&1
	echo Added front cover \'cover.jpg\'
fi

