#!/usr/bin/perl -w

# Create simple web page listing known information about an album, including
# artist, album, tracks, cover art, a review, and lyrics.
# 22 March 2002.

# Output file will be ARTIST_-_ALBUM.html

use File::Copy;
$dst = "/home/httpd/html/voter/info";

$line = `pwd`;
chomp $line;
$line =~ s/\/music\///;		# hack off "/music/" prefix
$line =~ s/\/$//;			# hack off trailing slash
( $artist, $album ) = split /\//, $line;
$artist = '' if ( $artist eq 'Various_Artists' );

$FILENAME = uc $artist . "_-_" if ( $artist ne '' );
$FILENAME .= uc $album;

$artist =~ s/_/ /g;			# replace underscores with spaces
$album =~ s/_/ /g;

$name = $artist . " - " if ( $artist ne '' );
$name .= $album;

open OUTFILE, ">$FILENAME.html";
print OUTFILE <<"EOF"
<HTML>
<HEAD>
	<TITLE>Album info for $name</TITLE>
</HEAD>

<BODY>

EOF
;

if ( -e 'cover.jpg' ) {
	print OUTFILE "<IMG ALIGN=\"RIGHT\" SRC=\"$FILENAME.jpg\" ALT=\"cover art\">\n\n";
}
elsif ( -e 'cover.gif' ) {
	print OUTFILE "<IMG ALIGN=\"RIGHT\" SRC=\"$FILENAME.gif\" ALT=\"cover art\">\n\n";
}

if ( $artist ne '' ) {
	print OUTFILE "<H1>$artist</H1>\n";
	print OUTFILE "<H2>$album</H2>\n\n";
}
else {
	print OUTFILE "<H1>$album</H1>\n\n";
}

open FILE, 'album.m3u';
print OUTFILE "<UL>\n";
foreach $track ( <FILE> )
{
	chomp $track;
	$track =~ s/.ogg$//;
	$track =~ s/_/ /g;
	$track =~ s/&/\&amp;/g;
	print OUTFILE "\t<LI>$track\n";
}
print OUTFILE "</UL>\n\n";
close FILE;

print OUTFILE "<HR>\n\n";

if ( -e 'review.txt' ) {
	open FILE, 'review.txt';
	foreach $line ( <FILE> )
	{
		print OUTFILE $line;
	}
	close FILE;
}
else {
	print OUTFILE "<P>Write a review for this album.</P>\n";
}

print OUTFILE "\n<HR>\n\n";

if ( -e 'lyrics.txt' ) {
	open FILE, 'lyrics.txt';
	print OUTFILE "<PRE>\n";
	foreach $line ( <FILE> )
	{
		$line =~ s/&/\&amp;/g;
		$line =~ s/</\&lt;/g;
		$line =~ s/>/\&gt;/g;
		print OUTFILE $line;
	}
	print OUTFILE "</PRE>\n\n";
	close FILE;
}
else {
	print OUTFILE "<P>Submit lyrics for this album.</P>\n\n";
}

print OUTFILE "</BODY>\n</HTML>\n";
close OUTFILE;

# Move files.

if ( copy("$FILENAME.html","$dst/$FILENAME.html") ) {
	unlink "$FILENAME.html";
}

if ( -e 'cover.jpg' ) {
	copy("cover.jpg","$dst/$FILENAME.jpg");
}
elsif ( -e 'cover.gif' ) {
	copy("cover.gif","$dst/$FILENAME.gif");
}

exit(0);
