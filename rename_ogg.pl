#!/usr/bin/perl -w

use My_Utils::Capitalize_Title;

# rename.pl 1.1 (c) 1999 Graham Mitchell
#	modified 2003-06-11 to use capitalize_tltle() helper function instead of
#	just ucfirst'ing everything itself.

# Renames a directory full of Track??.ogg to the track names (given in the
# input file) and generates playlist, both in one fell swoop.  Also, converts
# spaces to underscores if that's not done in the input file, changes all
# words in the track title to initial caps, and appends the extension of the
# original file (probably .ogg) to the end of the track title.  Also makes
# coffee sometimes, too.

$track_file = shift || "tracks";

# first read in list of real names from $track_file

open FILE, $track_file or die "Can't open $track_file: $!";
@track_names = <FILE>;
close FILE;

# zero out empty "playlist" of appropriate size

@playlist = (0) x @track_names;
@file_names = (0) x @track_names;

# generate file names without suffix

$pos = 0;
for $newname ( @track_names )
{
	$newname = capitalize_title($newname);
	$newname =~ s/ /_/g;
	$file_names[$pos++] = $newname;
}

# rename any existing Track?? files to the track name

opendir DIR, "." or die "Can't open current directory: $!";
for $oldname ( readdir DIR )
{
	chomp $oldname;
	next if $oldname =~ /^\./; 	# skip dotfiles
	next if $oldname =~ /\.m3u$/; 	# skip any existing playlist
	next if $oldname =~ /\.txt$/; 	# skip any existing playlist

	if ( $oldname =~ /track(\d+)/i )
	{
		# we have a filename with a number in it
		die "Invalid track # $1" if ( $1 > @track_names );

		$pos = $1 - 1;

		# get suffix
		@tempname = split /\./, $oldname;
		$suffix = '';
		$suffix = $tempname[-1];
		
		# append previous suffix to file name (adds to any existing suffix)
		$file_names[$pos] .= ".$suffix" if ( $suffix ne '' );

		# and get corresponding track name from the list
		$newname = $file_names[$pos];

		# rename it
		rename $oldname, $newname;

		# and add it to the playlist
		$playlist[$pos] = $newname;
	}
}
closedir DIR;

# add any pre-existing files in the directory (already named) to the playlist

if ( -e 'album.m3u' && -s 'album.m3u' )
{
	open FILE, 'album.m3u' or die "Can't open album.m3u for input: $!";
	for $oldname ( <FILE> )
	{
		chomp $oldname;
		$pos = 0;
		for ( $pos=0; $pos < @file_names; ++$pos )
		{
			if ( $oldname =~ m/$file_names[$pos]/i )
			{
				$playlist[$pos] = $oldname;
			}
		}
	}
	close FILE;
}

#and write the playlist
	
open FILE, ">album.m3u" or die "Can't open album.m3u for output: $!";
for ( @playlist ) {
	next if ( ! $_ );
	print FILE "$_\n";
}
close FILE;
