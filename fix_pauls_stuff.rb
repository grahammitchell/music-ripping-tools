#!/usr/bin/ruby -w

# 2006-06-10

# Okay, all the folders on Paul's iAUDIO have files with one or more problems.
#
# TODO: add a special case to prefix a zero in front of mp3 track numbers
#         from the tag, since they lose it

#  .) Some have underscores in their names and don't need them.
#  .) All of them (*.ogg and *.flac) need to be prefixed by their track number.
#  .) All flacs are tagged, so we can use metaflac to get the TRACKNUMBER.
#  .) oggs are tagged *iff* there is a file called "track_info.txt" in the cwd.
#  .) If there is a file called "tracks" in the cwd, oggs are *not* tagged
#     so we have to open the file "full_album.m3u" and use the position of
#     the filename in that file to figure out the correct track number.

#  Making things worse is that some filenames have already been 'done'.
#    That is, they've already got underscores removed and/or tracknumber
#    prefixes, so we'll have to watch for that.

def getTrackNumberFromTag( filename )
	if File.extname(filename) == '.ogg'
		num = %x{vorbiscomment -l "#{filename}" | grep TRACKNUMBER | cut -b 13-}
		num.chomp!
	elsif File.extname(filename) == '.flac'
		num = %x{metaflac --list "#{filename}" | grep TRACKNUMBER | cut -b 29-}
		num.chomp!
	elsif File.extname(filename) == '.mp3'
		num = %x{id3info "#{filename}" | grep TRCK | cut -b 42-}
		num.chomp!
	else
		num = '00'
	end
	return num
end


require 'find'
require 'fileutils.rb'

alreadyNumbered = %r{^\d\d[ab]* - }

# Get list of filenames of readable music files in current and sub directories

filenames = []
Find.find('.') do |path|
	next unless FileTest.file?(path)
	next unless ( File.extname(path)=='.ogg' or File.extname(path)=='.flac' or File.extname(path)=='.mp3' )
	next unless FileTest.readable?(path)
	filenames << path
end

filenames.each do |path|
	
	f = File.basename(path)
	dir = File.dirname(path)
	
	# number files?
	unless f.match(alreadyNumbered)
		if FileTest.exist?("#{dir}/tracks")
			# no tags, we've got to compute them from reading full_album.m3u
			lookup = []
			IO.foreach("#{dir}/full_album.m3u") { |line| lookup << line.chomp }

			pos = lookup.index(f)
			pos = ( pos.nil? ? 0 : pos )
			num = sprintf("%02d", pos+1 )
		else # if FileTest.exist?("#{dir}/track_info.txt")
			num = getTrackNumberFromTag(path)
		end
		# print "Prefixing #{dir}, #{f} with \"#{num}\"\n"
		FileUtils.cd( dir ) { FileUtils.mv(f, "#{num} - #{f}") }
	end
end


filenames = []
Find.find('.') do |path|
	next unless FileTest.file?(path)
	next unless ( File.extname(path) == '.ogg' or File.extname(path) == '.flac' or File.extname(path)=='.mp3' )
	next unless FileTest.readable?(path)
	filenames << path
end

filenames.each do |path|

	f = File.basename(path)
	dir = File.dirname(path)

	# remove underscores?
	if f.index('_')
		newf = f.gsub('_', ' ')
		FileUtils.cd( dir ) { FileUtils.mv(f, newf) }
	end
end
