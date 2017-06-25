package My_Utils::Lexical_Hash;

use strict;
use warnings;

BEGIN {
	use Exporter ();
	our ($VERSION, @ISA, @EXPORT);

        # set the version for version checking
        $VERSION     = 1.00;
        @ISA         = qw(Exporter);
        @EXPORT      = qw(&lexical_hash);

}

=head1 NAME

a function to generate a hash for a given title (of a movie, band, song,
book, etc) that puts things in the correct order with a simple ASCII sort

=head1 SYNOPSIS

	use My_Utils::Lexical_Hash;

	$name1 = <STDIN>;
	$name2 = <STDIN>;
	if ( lexical_hash($name1) lt lexical_hash($name2) )
	{
		echo "$name1 alphabetically precedes $name2.";
	}

=head1 DESCRIPTION

C<lexical_hash()> was written to take a song title of questionable
capitalization (say, from FreeDB), and produce a hash which is suitable as
a sort key for a traditional ASCII sort.

Any leading articles ('a', 'an', 'the') are moved to the end.  All
punctuation and spacing is removed (including, in fact, all non-letters),
and everything is forced to upper-case.

Eventually, the function will guess at proper names, so "James Taylor" will
hash to "TAYLOR JAMES" instead of "JAMES TAYLOR".

=head2 Examples:

	$foo = lexical_hash("The Cure");
	# $foo is "CURE THE"

	$foo = lexical_hash("The The");
	# $foo is "THE THE"

	$foo = lexical_hash("A Perfect Circle");
	# $foo is "PERFECT CIRCLE A"

	$foo = lexical_hash("The Crystal Method");
	# $foo is "CRYSTAL METHOD THE"

	$foo = lexical_hash("The Steve Miller Band");
	# $foo is "MILLER STEVE BAND THE"

	$foo = lexical_hash("The Jimi Hendrix Experience");
	# $foo is "HENDRIX JIMI EXPERIENCE THE"

	$foo = lexical_hash("Stevie Ray Vaughn and Double Trouble");
	# $foo is "VAUGHN STEVIE RAY AND DOUBLE TROUBLE"

	$foo = lexical_hash("Tori Amos");
	# $foo is "AMOS TORI"

	$foo = lexical_hash("Amos, Tori");
	# $foo is "AMOS TORI"

=head1 AUTHOR AND COPYRIGHT

Graham Mitchell, 2003-06-18

Released under the terms of the GNU General Public License (GPL), or at
your option, the Artistic License.

=cut

sub lexical_hash($;$)
{
	my $orig = shift;
	my $swap_proper_names = shift or 1;

	my %firstnames = (
		'alice' => 1,
		'ani' => 1,
		'arlo' => 1,
		'avril' => 1,
		'bing' => 1,
		'charlotte' => 1,
		'chris' => 1,
		'dave' => 1,
		'david' => 1,
		'del' => 1,
		'derek' => 1,
		'edie' => 1,
		'eric' => 1,
		'fiona' => 1,
		'huey' => 1,
		'jack' => 1,
		'james' => 1,
		'janis' => 1,
		'jennifer' => 1,
		'jimi' => 1,
		'joe' => 1,
		'john' => 1,
		'johnny' => 1,
		'joseph' => 1,
		'lyle' => 1,
		'melissa' => 1,
		'monte' => 1,
		'monty' => 1,
		'norah' => 1,
		'paul' => 1,
		'sara' => 1,
		'sarah' => 1,
		'sinead' => 1,
		'stephen' => 1,
		'steve' => 1,
		'steven' => 1,
		'stevie ray' => 1,
		'susan' => 1,
		'tim' => 1,
		'tori' => 1,
		'wolfgang amadeus' => 1,
		'LONGEST_KEY' => 2,
	);

	my %exeptions = (
		'alice' => 'alice in chains',
		'del' => 'del the funk',
		# 'del' => 'del tha funk',
		'jethro' => 'jethro tull',
		'johnny' => 'johnny q public',
		'monty' => 'monty python',
	);

	# Munch whitespace and split up the line into a list of words.
	chomp $orig;
	$orig = lc $orig;
	my @words = split(' ', $orig);
	my $length = @words;

	# Find longest key in list of first names
	my $runlength = $firstnames{'LONGEST_KEY'};

	# Now generate all substrings from length 1 up to $runlength see
	#  if any of them are found in %firstnames



	my $capsword = join(' ', @words);
	return uc $capsword;
}

1;   # don't forget to return a true value from the file
