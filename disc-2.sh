#!/bin/bash

# Tag Disc 1 of two-disc set

# 2012-11-13 - initial version

metaflac --set-tag=DISCNUMBER=02 *.flac
metaflac --set-tag=TOTALDISCS=02 *.flac
/home/mitchell/code/ripping/tagsort.rb
