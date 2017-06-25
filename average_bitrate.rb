#!/usr/bin/ruby

# 2006-06-07

# Uses mp3info to find the average bitrate and duration (in seconds) for a single
# track.  It then weights each bitrate by track length, so that longer songs
# contribute more to the average and computes an overall average bitrate for all mp3
# files in the current directory

# First make sure mp3info can be called
unless system('mp3info -h > /dev/null')
	warn "Unable to run mp3info.  Is it installed and in the PATH?"
	exit 1
end

require 'find'

# Get list of filenames of readable mp3s in current and sub directories

filenames = []
Find.find('.') do |path|
	next unless FileTest.file?(path)
	next unless File.extname(path) == '.mp3'
	next unless FileTest.readable?(path)
	filenames << path
end

times = []
bitrates = []
filenames.each do |file|
	s = %x{mp3info -F -r a -p "%S %r" "#{file}"}
	next unless $?.exitstatus == 0
	( t, b ) = s.split
	times << t.to_i
	bitrates << b.to_f
end

total_secs = times.inject {|sum, x| sum + x}

total_bits = 0
for i in 0...times.length
	t = times[i]
	b = bitrates[i]
	total_bits += b*t
end

printf("Averaged %.2f Kbps over %d files (%d total seconds)\n", total_bits / total_secs, times.length, total_secs)
