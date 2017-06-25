#!/bin/bash

# Error codes
ARGUMENT_NOT_DIRECTORY=10

path="$1"
if [ ! -d "$path" ]; then
	echo "Path "$path" is not a directory"
	exit $ARGUMENT_NOT_DIRECTORY
fi

find "$path" -type f -name '*.flac' -exec /home/mitchell/code/ripping/aacfromflac.sh '{}' \;

