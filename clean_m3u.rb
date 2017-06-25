#!/usr/bin/ruby -w

# 2007-08-16

# Takes out all the cruft that Amarok (I think) puts into
#   album.m3u and full_album.m3u

require "#{File.dirname $0}/utils.rb"
require 'tempfile'
require 'fileutils.rb'

# Get list of playlist files in the current directory
filenames = filesByExtension( '.', '.m3u' )
Kernel.exit(0) if filenames.empty?

# Start fixing each file
filenames.each do |i|

	out = Tempfile.new( "clean_m3u" )

	out.open
	File.open( i, "r" ).each do |line|
		next if ( line =~ /^#/ )
		if ( line =~ /^\/music\// ) then line = File.basename( line ) end
		out << line
	end
	out.close

	FileUtils.cp( out.path, i )

end

