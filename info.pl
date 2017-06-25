#!/usr/bin/perl -w

# Create information files to automate moving/renaming of albums worth of ogg
# files.  4 January 2002.

# "name-FOO" will contain
#	artist
#	album
# and FOO will be the Windows-legal version of ARTIST_-_ALBUM (for human eyes)

# "tracks" will contain the names of each track, one per line.

%illegal_win_chars = (
	'\/' => '-',
	"\\\\" => '-',
	'\:' => '-',
	'\*' => "KILL",
	'\?' => "KILL",
	'\"' => "'",
	'<' => '(',
	'>' => ')',
	'\|' => '-',
);

# %illegal_unix_chars = (
#	'/' => '\\',
# );

print "Artist: ";
$artist = <STDIN>;
chomp $artist;
$artist = "various artists" if ( $artist eq '' ) ;
print "Album: ";
$album = <STDIN>;
chomp $album;

# break up the artist name into individual words so we can ucfirst it
@tempname = split / /, $artist;
# now ucfirst it
for ( $i=0; $i<@tempname; ++$i ) {
	$tempname[$i] = ucfirst $tempname[$i];
}
# and put it back together
$artist = join "_", @tempname;

#ditto for the album
@tempname = split / /, $album;
for ( $i=0; $i<@tempname; ++$i ) {
	$tempname[$i] = ucfirst $tempname[$i];
}
$album = join "_", @tempname;

$win_artist = uc $artist;
$win_album = uc $album;

# Filter out characters not allowed in Windows filenames
foreach $char ( keys %illegal_win_chars )
{
	$substitute_char = $illegal_win_chars{ $char };
	if ( $substitute_char eq "KILL" ) {
		# delete the offending character
		$win_artist =~ s#$char##g;
		$win_album  =~ s#$char##g;
	} else {
		# replace the offending character with a similar one
		$win_artist =~ s#$char#$substitute_char#g;
		$win_album  =~ s#$char#$substitute_char#g;
	}
}

# We should be okay to create the thing now.

$filename = "name-$win_artist\_-_$win_album";
open FILE, ">$filename" or die "Can't create \"$filename\": $!\n";
print FILE $artist, "\n", $album, "\n";
close FILE;

# Get tracknames.

$i = 1;
$track = 'HI';
while ( $track ne '' ) {
	print "Track $i: ";
	$track = <STDIN>;
	chomp $track;
	push @tracks, $track if ( $track ne '' );
	$i++;
}

# If they typed anything at all, put them in the file.

if ( @tracks ) {
	open FILE, ">tracks" or die "Can't create \"tracks\": $!\n";
	foreach $track ( @tracks )
	{
		print FILE $track, "\n";
	}
	close FILE;
}

exit(0);
