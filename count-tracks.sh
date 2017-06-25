#!/bin/bash

count=$( wc -l track_info.txt | cut --delim=' ' -f 1 )
let "count -= 3"
printf "%02d\n" $count
