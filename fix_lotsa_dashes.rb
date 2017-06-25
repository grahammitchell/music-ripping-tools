#!/usr/bin/ruby

# 2006-06-10

require 'find'
require 'fileutils.rb'


filenames = []
Find.find('.') do |path|
	next unless FileTest.file?(path)
	next unless ( File.extname(path) == '.ogg' or File.extname(path) == '.flac' )
	next unless FileTest.readable?(path)
	filenames << path
end

pattern = %r{^(\d\d[ab]* - )( - )+(.*)$}

filenames.each do |path|
	
	f = File.basename(path)
	dir = File.dirname(path)
	
	# number files?
	if f.match(pattern)
		( num, dashes, rest ) = f.match(pattern).captures
		FileUtils.cd( dir ) { FileUtils.mv(f, "#{num}#{rest}") }
	end
end

