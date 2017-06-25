#!/usr/bin/ruby -w

# 2006-07-22
# 2006-08-08	added "proper" command-line handling with optparse

# Replaces the specified tag in all FLAC files in the current directory, but
#   *without* changing the order of the tags.

require "#{File.dirname $0}/utils.rb"
require 'optparse'

tags = {}
OptionParser.new do |opts|
	opts.banner = "Usage: #{$me} -t [tags] [files]"
	opts.on("-t", "--tag TAG=VALUE", /[A-Z_]+\=[[:print:]]+/, "taggg") do |o|
		tag, value = o.split('=',2)
		tag.upcase!
		tags[tag] = value
	end
end.parse!

# Do we have any tags to modify/add?
fail "#{$me}: You must supply at least one tag/value pair.\n" if tags.empty?

# Get list of FLACs in the current directory
if ARGV.empty? || ( ARGV.length == 1 && ARGV[0] == "*.flac" ) then
	filenames = filesByExtension( '.', '.flac' )
else
	filenames = []
	ARGV.each { |f| filenames << f if ( File.extname(f) == '.flac' ) }
end

fail "#{$me}: no files to tag\n" if filenames.empty?

# Start fixing each file
seen = []
filenames.each do |i|
	base = File.basename( i, '.flac' )
	oldf = base + '_old.txt'
	newf = base + '_new.txt'
	_i, _oldf, _newf = shell_escape( i, oldf, newf )

	cmd = 'metaflac --preserve-modtime --no-utf8-convert'
	
	# Get existing tags out of FLAC file
	system(%Q/#{cmd} --export-tags-to="#{_oldf}" "#{_i}"/)

	# Create a new file with the same tags, but with our replacement
	fixed = File.open( newf, "w" )
	broken = File.open( oldf, "r" )

	broken.each do |line|
		cur_tag = line.split('=')[0]
		tags.each do |tag, value|
			if ( cur_tag == tag ) then
				fixed << "#{tag}=#{value}\n"
				seen << tag
			else
				fixed << line
			end
		end
	end
	broken.close

	# Append any tags remaining that weren't already in the file
	tags.each { |t, v| fixed << "#{t}=#{v}\n" if ! seen.include?(t) }
	fixed.close

	# Retag the FLAC file
	system(%Q/#{cmd} --remove-all-tags --import-tags-from="#{_newf}" "#{_i}"/)

	# Remove those temporary files
	File.delete( oldf, newf )
end

