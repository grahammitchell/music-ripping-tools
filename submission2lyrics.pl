#!/usr/bin/perl -w

use strict;
use CGI;

my $file = shift or die "You must supply a filename.\n";
open FILE, "<$file" or die "Couldn't open file \"$file\": $!\n";

my $q = new CGI(\*FILE);

my ( $artist, $album, $tracks, $i, $status, $x, $url );

$artist = $q->param('artist');
$album = $q->param('album');
$url = $q->param('cover_url');

print STDERR "wget -O cover.jpg $url\n";
print "$artist\n";
print "$album\n\n";

$tracks = $q->param('num_songs');

$i = 1;
$x = 'A';

while ( $i <= $tracks )
{
	print $q->param("track_$x\_num"), ") ";
	print $q->param("track_$x\_title");
	$status = $q->param("track_$x\_lyricstatus");
	print " [$status]" if ( $status ne 'clean' );
	print "\n\n";

	print $q->param("track_$x\_lyrics"), "\n\n";

	$i++;
	$x++;
}

exit(0);

