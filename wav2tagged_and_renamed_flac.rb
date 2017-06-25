#!/usr/bin/ruby -w

# 2006-07-21
# 2011-05-19 - only preserve replaygain tags, not (presumably) erroneous other tags
# 2011-05-19 - add embedding of cover.jpg, if present
# 2012-02-09 - add TOTALTRACKS tag, too
# 2012-10-25 - edited shell_escape to backslash escape dollar signs in filenames. Thanks, Lecrae.
# 2012-11-15 - strip leading and trailing whitespace from track titles, in case I was sloppy.
# 2012-11-27 - add back in missing newline from track title, since we accidentally stripped that, too.

# Encode all wav files in the current directory to FLACs, then open and
#   parse 'track_info.txt' to get tagging info.

require "#{File.dirname $0}/utils.rb"

# Find out if there are any WAVs to compress
wavcount = 0
Dir.foreach('.') do |f|
	wavcount += 1 if File.extname(f) == '.wav'
end

# Compress any WAVs to FLAC
system("flac --delete-input-file --replay-gain *.wav") if wavcount > 0

# Now see if we can start tagging
fail "#{$me}: 'track_info.txt' not found.\n" if not File.exist? 'track_info.txt'

# Get track count
totaltracks = %x{wc -l 'track_info.txt'}.to_i - 3

# Get tags common to every file
info   = File.open('track_info.txt')
artist = info.gets
album  = info.gets
date   = info.gets
trackn = 1

# Get list of FLACs in this directory
filenames = filesByExtension( '.', '.flac' )

playlist = File.new('full_album.m3u', "a")

cmd = 'metaflac --preserve-modtime --no-utf8-convert'
pic = ''
# pic = ' --import-picture-from=cover.jpg' if File.exist? 'cover.jpg'

# Start tagging each file
print "Tagging and renaming files..."
filenames.sort.each do |i|
	base = File.basename( i, '.flac' )
	oldf = base + '_old.txt'
	newf = base + '_new.txt'
	_i, _oldf, _newf = shell_escape( i, oldf, newf )

	title = info.gets
	title.strip!
	title += "\n"
	
	# Get existing (replaygain) tags out of FLAC file
	system(%Q/#{cmd} --export-tags-to="#{_oldf}" "#{_i}"/)
	# Create a new file with the tags we want
	File.open( newf, "w" ) do |tags|
		tags << "ARTIST=" << artist
		tags <<  "ALBUM=" <<  album
		tags <<  "TITLE=" <<  title
		tags <<   "DATE=" <<   date
		tags.printf("TRACKNUMBER=%02d\n", trackn)
		tags.printf("TOTALTRACKS=%02d\n", totaltracks)
		trackn += 1
		# Append existing tags to the end of our new tags
		File.open( oldf, "r" ) do |f|
			f.each { |line| tags << line if line =~ /^REPLAYGAIN_/ }
		end
	end

	# Retag the FLAC file
	system(%Q/#{cmd}#{pic} --remove-all-tags --import-tags-from="#{_newf}" "#{_i}"/)

	# Remove those temporary files
	File.delete( oldf, newf )

	# Get a filename from the track title, replacing underscores with spaces
	#   and forward slashes with the url-encoding '%2F'
	name = title.chomp.gsub(' ', '_')
	name.gsub!('/','%2F')
	name += '.flac'

	# Append this filename to the playlist
	playlist << name << "\n"

	# And rename the file from 'track04.cdda.flac' to 'North_Dakota.flac'
	File.rename( i, name )
end
puts "done."

playlist.close
info.close

puts "All done."

