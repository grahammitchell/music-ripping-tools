#!/usr/bin/ruby -w

# 2006-06-27

# 1) Create 'name-foo'
# 2) Start 'track_info.txt'
# 3) Do the same things as 'rip_and_chown.sh' did.

require 'find'
require 'fileutils.rb'

print "Creating name-foo..."
dirs = Dir.getwd.split('/')
File.open( 'name-foo', 'w' ) do |file|
	file << dirs[-2] << "\n" << dirs[-1] << "\n"
end
print "done.\n"

print "Starting track_info.txt..."
File.open( 'track_info.txt', 'w' ) do |file|
	file << dirs[-2].gsub('_',' ') << "\n" << dirs[-1].gsub('_',' ') << "\n"
end
print "done.\n"

print "Changing ownership for current and parent directory..."
File.chown( 1000, 1000, ".", ".." ) or exit!(1)
print "done.\n"

print "Ripping tracks from CD..."
exit!(1) unless system("cdparanoia -d /dev/sr0 -B 1-")
print "done.\n"

filenames = []
Find.find('.') do |path|
        next unless FileTest.file?(path)
        next unless File.extname(path) == '.wav'
        next unless FileTest.readable?(path)
        filenames << path
end

print "Changing ownership for wav files..."
filenames.each { |file|  File.chown( 1000, 1000, file ) or exit!(1) }
print "done.\n"

print "Ejecting CD..."
exit!(1) unless system("eject /dev/sr0")
print "done.\n"

print "All done.\n"
