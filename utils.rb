#!/usr/bin/ruby -w

# 2006-07-22
# 2012-10-25 - edited shell_escape to backslash escape dollar signs in filenames.

# Just some methods I seem to be using often.

$me = File.basename $0

# Escapes double quotes, because Ruby doesn't do this for you when passing
#   filenames to system()
def shell_escape( *a )
	b = a.collect { |s| s.gsub('"','\"').gsub('$','\$') }
	return b[0] if b.length == 1
	return b
end


# Returns array of files in the given directory whose extensions
#   match one of the list of given extensions
def filesByExtension( dir, *ext )
	a = []
	Dir.foreach(dir) do |f|
		next unless FileTest.file?(f)
		next unless ext.include? File.extname(f)
		next unless FileTest.readable?(f)
		a << f
	end
	return a
end


# Same as above, but searches in all subdirectories of the given dir, too.
def filesByExtensionDeep( dir, *ext )
	require 'find'
	a = []
	Find.find(dir) do |f|
		next unless FileTest.file?(f)
		next unless ext.include? File.extname(f)
		next unless FileTest.readable?(f)
		a << f
	end
	return a
end


