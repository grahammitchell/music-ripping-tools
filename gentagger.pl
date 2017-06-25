#!/usr/bin/perl -w

use My_Utils::Capitalize_Title;

# gentagger.pl
# 2003-07-09

# Generates a shell script which can be run to tag "track title" and "track
# number" information to Oggs given the file "tracks".  The shell script
# uses vorbiscomment to do its magic.

$track_file = shift || "tracks";

# first read in list of real names from $track_file

open FILE, $track_file or die "Can't open $track_file: $!";
@track_names = <FILE>;
close FILE;

$pos = 0;
for $name ( @track_names )
{
	$name = capitalize_title($name);
	$names[$pos++] = $name;
}

open FILE, ">temp_tag.sh" or die "Can't write \"temp_tag.sh\": $!";
print FILE "#!/bin/sh\n\n";

opendir DIR, "." or die "Can't open current directory: $!";
for $oggfile ( readdir DIR )
{
	chomp $oggfile;
	next if $oggfile =~ /^\./; 	# skip dotfiles
	next if $oggfile =~ /\.m3u$/; 	# skip any existing playlist
	next if $oggfile =~ /\.txt$/; 	# skip any existing playlist
	next if $oggfile =~ /\.wav$/; 	# skip any WAVs

	if ( $oggfile =~ /track(\d+)/i )
	{
		# we have a filename with a number in it
		die "Invalid track # $1" if ( $1 > @names );

		$pos = $1 - 1;
		$tracknumber = int($1); # a cast so we lose the leading '0'

		# and get corresponding track name from the list
		$name = $names[$pos];

		print FILE "vorbiscomment -a $oggfile -t \"title=$name\"";
		print FILE " -t \"tracknumber=$tracknumber\"\n";

	}
}
closedir DIR;

close FILE;
