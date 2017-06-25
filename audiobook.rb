#!/usr/bin/ruby -w

# 2006-08-09

# Same as 'rip_and_chown.rb', but with multiple discs into separate
#   subdirectories.

fail "You must supply a number of discs on the command-line.\n" if ARGV.empty?

require "#{File.dirname $0}/utils.rb"

File.chown( 500, 501, ".", ".." ) or exit!(1)
dirs = Dir.getwd.split('/')
dirs[-2].gsub!('_',' ') ; dirs[-1].gsub!('_',' ')

n = ARGV[0].to_i
1.upto(n) do |disc|  # God, I love Ruby.

	# create new subdir (if needed) and change into it
	dir = "disc#{disc}"
	Dir.mkdir(dir) if ! File.exists? dir
	Dir.chdir(dir)

	# Rip and chown the files into that directory, and eject the disc
	print "Ripping CD #{disc} of #{n}...\n"
	exit!(1) unless system("cdparanoia -d /dev/scd0 -B 1-")
	wavs = filesByExtension( '.', '.wav' )
	wavs.each { |file|  File.chown( 500, 501, file ) or exit!(1) }
	exit!(1) unless system("eject /dev/scd0")

	# Write dummy numbers to the file, because they're better than nothing.
	File.open( 'track_info.txt', 'w' ) do |file|
		file << dirs[-2] << "\n" << dirs[-1] << "\nsomeyear\n"
		1.upto(wavs.length) { |track| file.printf("%d%02d\n", disc, track) }
	end

	# Back out and prompt for a new disc if this wasn't the last one.
	Dir.chdir("..")
	if ( disc < n ) then
		print "Insert disc #{disc+1}. Press ENTER to continue... "
		$stdin.gets
	end
end
