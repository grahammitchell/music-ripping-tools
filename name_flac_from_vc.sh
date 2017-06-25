#!/usr/bin/env bash

for i in *.flac
do
	name=`metaflac --list $i | grep TITLE= | cut -b 23- | tr " " "_"`
	mv $i $name.flac
done
