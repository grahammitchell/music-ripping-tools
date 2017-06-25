#!/usr/bin/perl -w

use File::Copy;

# Move gunk from named folder (assumed to be a subdir of /home/music) into
# the appropriate folder under /music.

$src = shift or die "You must supply a folder to move from.\n";

# Try to figure out our destination folder.
opendir DIR, "/home/music/$src" or die "No such folder \"/home/music/$src\": $!\n";
@allfiles = readdir DIR;
closedir DIR;

$names_file = 0;
foreach $file ( @allfiles )
{
	if ( $file =~ m/^name-/ )
	{
		$names_file = $file;
		last;
	}
}

if ( ! $names_file )
{
	print STDERR "There is no file beginning with \"name-\", so I can't do it.\n";
	open FILE, "/home/music/$src/tracks" or die "And I can't even open a ",
	"trackfile to give you a hint: $!\n";
	foreach $track ( <FILE> )
	{
		chomp $track;
		print STDERR "\t$track\n";
	}
	close FILE;
	die "Hope that helps, at least.\n";
}

# If we're still around, we found a file to tell us where to go.

# Strip carriage returns
system '/bin/sh', '/home/mitchell/code/ripping/stripcr.sh', "/home/music/$src/$names_file";

open FILE, "/home/music/$src/$names_file" or die "Can't open $names_file: $!\n";
$artist_dir = <FILE>;
chomp $artist_dir;
$album_dir = <FILE>;
chomp $album_dir;
close FILE;

# Now we'll see if this folder already exists
if ( chdir "/music/$artist_dir/" ) {
	print "/music/$artist_dir/ already exists.\n";
}
elsif ( mkdir "/music/$artist_dir/" ) {
	print "/music/$artist_dir/ successfully created.\n";
	chdir "/music/$artist_dir" or die "...but couldn't chdir: $!\n";
}
else {
	die "Couldn't create \"/music/$artist_dir\": $!\n";
}

# Check the same for the album (just in case)
if ( chdir "/music/$artist_dir/$album_dir" ) {
	print "/music/$artist_dir/$album_dir/ already exists.\n";
}
elsif ( mkdir "/music/$artist_dir/$album_dir" ) {
	print "/music/$artist_dir/$album_dir/ successfully created.\n";
	chdir "/music/$artist_dir/$album_dir" or die "...but couldn't chdir: $!\n";
}
else {
	die "Couldn't create \"/music/$artist_dir/$album_dir\": $!\n";
}

# If we're still around, we've chdir'ed into the correct folder.  Time to
# copy files around.

$src = "/home/music/$src";
$dst = "/music/$artist_dir/$album_dir";

# First see if there's anything in the $dst directory
opendir DIR, $dst or die "Couldn't opendir \"$dst/\": $!\n";
@allfiles = readdir DIR;
closedir DIR;

# Don't fret about dotfiles, since they won't be harmed.
$count = 0;
foreach $file ( @allfiles )
{
	if ( $file ne '.' && $file ne '..' && $file ne '.alpha' ) {
		++$count;
	}
}

if ( $count > 0 )
{
	print "$dst isn't empty.  It contains:\n";
	foreach $file ( @allfiles )
	{
		next if ( $file eq '.' || $file eq '..' );
		print "\t$file\n";
	}
	print "Okay to proceed? ";
	$choice = <STDIN>;
	chomp $choice;
	if ( $choice ne 'Y' && $choice ne 'y' ) {
		print STDERR "Okay, aborting.\n";
		exit(0);
	}
}

# Okay, let's do this piece.

print "Moving name file...";
if ( copy("$src/$names_file","$dst/name") ) {
	unlink "$src/$names_file";
}
else {
	print STDERR "\nUnable to move $src/$names_file to $dst/name: $!\n";
	exit(1);
}
print "done.\n";

print "Moving other files...\n";
opendir DIR, $src or die "Couldn't opendir \"$src/\": $!\n";
foreach $file ( readdir DIR )
{
	next if ( $file =~ m/^\./ ); # skip dotfiles
	print "\t$file...";
	if ( copy( "$src/$file", "$dst/$file" ) ) {
		unlink "$src/$file";
	}
	else {
		print STDERR "\nUnable to move $src/$file to $dst/$file: $!\n";
		exit(1);
	}
}
closedir DIR;
print "\n...all files moved.\n\n";

# Now, hopefully we can trust the shell to handle this.
# Do post-processing (renaming, permissions, etc)

print "Post-processing...\n";
system '/bin/sh', '/home/mitchell/code/ripping/own.sh';

# And let's go home.

exit (0);

