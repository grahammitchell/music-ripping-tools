#!/usr/bin/env bash

# 2006-05-31 - original version?  Last revision?
# 2012-10-02 - updated to use eyeD3 instead

eyeD3 --version > /dev/null || die "eyeD3 not in path."

for i in *.mp3
do
	num=$( eyeD3 "$i" | grep track | cut -b 16- )
	num="${num%"${num##*[![:space:]]}"}"   # remove trailing whitespace characters
	len=`echo -n "$num" | wc -c`
	if [ $len -lt 2 ]
	then
		num=0$num
	fi
	mv "$i" "${num}._$i"
	echo ${num}._$i
done
