#!/usr/bin/ruby -w

# 2006-06-26

# List all ogg files that have an identically-named flac in the same directory.

require 'find'
require 'fileutils.rb'

# find them
filenames = []
Find.find('.') do |path|
	next unless FileTest.file?(path)
	next unless ( File.extname(path)=='.ogg' )
	next unless FileTest.readable?(path)
	filenames << path
end

# list them
filenames.each do |path|
	puts( File.dirname(path) ) if FileTest.file?( path.sub(/.ogg$/,'.flac') )
end

