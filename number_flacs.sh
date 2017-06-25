#!/bin/bash

for f in *.flac
do
	num=$( metaflac --list --block-type=VORBIS_COMMENT -- "$f" | grep TRACKNUMBER | cut -b 29- )
	# from the bash-hackers wiki (http://wiki.bash-hackers.org/syntax/arith_expr)
	# $(( 10#$x )) forces $x to be interpreted as a decimal, so that tracks like '08' don't mess up stuff.
	printf -v num00 "%02d" $(( 10#$num ))
	mv "$f" "${num00}_$f"
	echo "${num00}_$f"
done
