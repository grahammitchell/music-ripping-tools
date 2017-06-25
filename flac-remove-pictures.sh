#!/bin/bash

# 2012-02-09
# Remove any embedded images from all FLACs in the current directory

metaflac --remove --block-type=PICTURE --dont-use-padding *.flac
