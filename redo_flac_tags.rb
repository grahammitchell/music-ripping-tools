#!/usr/bin/ruby -w

# 2006-08-08
# 2008-07-28 - fixed to not assume that alpha order of flacs is album order
# 2011-05-19 - only preserve replaygain tags, not (presumably) erroneous other tags

# Just retag all FLACs in the current directory from what's in 'track_info.txt'
#  This is probably necessary because I screwed up something

require "#{File.dirname $0}/utils.rb"

# Now see if we can start tagging
fail "#{$me}: 'track_info.txt' not found.\n" if not File.exist? 'track_info.txt'

# Get tags common to every file
info   = File.open('track_info.txt')
artist = info.gets
album  = info.gets
date   = info.gets

# Make lookup table for tracknumber given filename
trackn = 1
tracknumbers = {}
while not info.eof? do
	title = info.gets.chomp
	tracknumbers[ title.gsub(/ /, '_') ] = trackn
	trackn += 1
end
info.close

# Get list of FLACs in this directory
filenames = filesByExtension( '.', '.flac' )

# Start tagging each file
print "Retagging files..."

filenames.sort.each do |i|
	base = File.basename( i, '.flac' )
	oldf = base + '_old.txt'
	newf = base + '_new.txt'
	_i, _oldf, _newf = shell_escape( i, oldf, newf )

	cmd = 'metaflac --preserve-modtime --no-utf8-convert'
	title = base.gsub(/_/, ' ') + "\n"
	trackn = tracknumbers[ base ]
	
	# Get existing (replaygain) tags out of FLAC file
	system(%Q/#{cmd} --export-tags-to="#{_oldf}" "#{_i}"/)
	# Create a new file with the tags we want
	File.open( newf, "w" ) do |tags|
		tags << "ARTIST=" << artist
		tags <<  "ALBUM=" <<  album
		tags <<  "TITLE=" <<  title
		tags <<   "DATE=" <<   date
		tags.printf("TRACKNUMBER=%02d\n", trackn)
		# Append existing tags to the end of our new tags, if present
		if File.exist? oldf 
			File.open( oldf, "r" ) do |f|
				f.each { |line| tags << line if line =~ /^REPLAYGAIN_/ }
			end
		end
	end

	# Retag the FLAC file
	system(%Q/#{cmd} --remove-all-tags --import-tags-from="#{_newf}" "#{_i}"/)

	# Remove those temporary files
	File.delete( oldf ) if File.exist? oldf 
	File.delete( newf )
end
puts "done."

