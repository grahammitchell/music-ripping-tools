#!/bin/sh

path=`dirname $0`

if [ -s tracks ]
then

	$path/gentagger.pl tracks
	chmod 774 temp_tag.sh
	./temp_tag.sh
	rm -f temp_tag.sh

else
	echo Error: no file named \"tracks\".
fi

