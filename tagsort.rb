#!/usr/bin/ruby -w

# 2006-07-22 - original version
# 2011-08-19 - added option for what.cd tags

# Changes the order of the tags in all FLAC files in the current directory
#   to be "canonical", because that matters to me.

require "#{File.dirname $0}/utils.rb"
require 'tempfile'

# Get list of FLACs in the current directory
filenames = filesByExtension( '.', '.flac' )
fail "#{$me}: no FLAC files found in current directory\n" if filenames.empty?

order = %w{
	ARTIST
	ALBUM
	TITLE
	DATE
	TRACKNUMBER
	TOTALTRACKS
	DISCNUMBER
	TOTALDISCS
	REPLAYGAIN_REFERENCE_LOUDNESS
	REPLAYGAIN_TRACK_PEAK
	REPLAYGAIN_TRACK_GAIN
	REPLAYGAIN_ALBUM_PEAK
	REPLAYGAIN_ALBUM_GAIN
}

whatcd_order = %w{
	ARTIST
	ALBUM
	TITLE
	DATE
	TRACKNUMBER
	TOTALTRACKS
	GENRE
	ALBUM\ ARTIST
	ALBUMARTIST
	REPLAYGAIN_REFERENCE_LOUDNESS
	REPLAYGAIN_TRACK_GAIN
	REPLAYGAIN_TRACK_PEAK
	REPLAYGAIN_ALBUM_GAIN
	REPLAYGAIN_ALBUM_PEAK
	COMMENT
}



if not((ARGV & %w{--whatcd -w}).empty?) # & is set intersection
	order = whatcd_order
end

# Start fixing each file
filenames.each do |i|
	_i = shell_escape( i )
	sorted = Tempfile.new( "tagsort.sorted." )
	newf = sorted.path
	unsorted  = Tempfile.new( "tagsort.unsorted." )
	oldf = unsorted.path
	unsorted.close

	cmd = 'metaflac --preserve-modtime --no-utf8-convert'
	
	# Get existing tags out of FLAC file into tempfile
	system(%Q/#{cmd} --export-tags-to="#{oldf}" "#{_i}"/)

	unsorted.open
	# And stick them in a hash
	tags = Hash.new
	unsorted.each do |line|
		k, v = line.split('=',2)
		tags[k] = v.chomp
	end
	unsorted.close

	# Create a new file with the same tags, but in a different order
	order.each do |k|
		sorted << "#{k}=#{tags[k]}\n" if tags.has_key?(k)
	end
	sorted.close

	# Retag the FLAC file
	system(%Q/#{cmd} --remove-all-tags --import-tags-from="#{newf}" "#{_i}"/)
end

