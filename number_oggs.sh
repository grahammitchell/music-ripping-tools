#!/usr/bin/env bash

# 2006-06-26 - initial version? (or last modification)
# 2012-07-04 - added multi-disc awareness, and now uses printf

for i in *.ogg
do
	tracknum=$( vorbiscomment -l "$i" | grep TRACKNUMBER | cut -b 13- )
	multidisc=$( vorbiscomment -l "$i" | grep TOTALDISCS )
	if [ -n "$multidisc" ]; then
		discnumber=$( vorbiscomment -l "$i" | grep DISCNUMBER | cut -b 12- )

		# from the bash-hackers wiki (http://wiki.bash-hackers.org/syntax/arith_expr)
		# $(( 10#$x )) forces $x to be interpreted as a decimal, so that tracks like '08' don't mess up stuff.
		printf -v tracknum "%d%02d" $discnumber $(( 10#$tracknum ))
	fi
	mv "$i" "${tracknum}_$i"
	# echo "${tracknum}_$i"
done
