#!/usr/bin/perl -w

# 2004-03-02 - original version
# 2011-06-09 - changed from id3v1 only to both v1 and v2, removed 30-char trim

# Reads in a file passed in on the command line, and outputs a list of
#  command-line arguments to set the appropriate tags in lame.

# Doesn't have a terminating newline, so you can do this:

#	$ lame foo.wav `txt2lame_opt.pl foo.txt`

# It's assumed that the file opened has a format like so:
# ARTIST=Passion
# ALBUM=One Day Live
# TITLE=This Is the Noise We Make
# TRACKNUMBER=01
# DATE=2000-10-24

# ...which is the output from
# 	$ metaflac --export-tags-to=foo.txt --no-utf8-convert foo.flac

%switches = (
	'ARTIST' => '--ta' ,
	'ALBUM' => '--tl' ,
	'TITLE' => '--tt' ,
	'TRACKNUMBER' => '--tn' ,
	'DATE' => '--ty' ,
);

$filename = shift or exit(0);

open FILE, $filename or exit(0);

$output = '';
foreach $line ( <FILE> )
{
	chomp $line;
	next if ( $line !~ m/=/ );
	next if ( $line =~ m/^REPLAYGAIN/ );

	( $tag, $value ) = split /=/, $line;

	# shorten
	if ( $tag eq 'DATE' ) {
		$value = substr($value,0,4);
	} elsif ( $tag eq 'TRACKNUMBER' ) {
		$value = 255 if ( $value > 255 );
	} elsif ( $tag eq 'ARTIST' || $tag eq 'ALBUM' || $tag eq 'TITLE' ) {
		# $value = substr($value,0,30);
		;
	} else {
		# unrecognized tag, skip it
		next;
	}

	# quote any quotes
	$value =~ s/"/\\"/g;

	$switch = $switches{ $tag };

	$output .= ' ' if ( $output ne '' );
	$output .= "$switch \"$value\"";
}

$output .= ' --add-id3v2' if ( $output ne '' );

print $output;

exit(0);
