package My_Utils::Capitalize_Title;

use strict;
use warnings;

BEGIN {
	use Exporter ();
	our ($VERSION, @ISA, @EXPORT);

        # set the version for version checking
        $VERSION     = 1.00;
        @ISA         = qw(Exporter);
        @EXPORT      = qw(&capitalize_title);

}

=head1 NAME

a function to properly capitalize a title (of a book, song, or movie).

=head1 SYNOPSIS

	use My_Utils::Capitalize_Title;

	foreach $title ( <STDIN> )
	{
		$newtitle = capitalize_title($title);
		print "$newtitle\n";
	}

=head1 DESCRIPTION

C<capitalize_title()> was written to take a song title of questionable
capitalization (say, from FreeDB), and fix it according to standard
capitalization rules.

The ruleset I used came from
L<http://aitech.ac.jp/~ckelly/midi/help/caps.html>.

=over

=item 1. The first and last words of the title are always capitalized.

=item 2. Articles, conjunctions, and prepositions shorter than five letters
are lower-case (unless, of course, they are the first or last words).

=item 3. Prepositions I<are> capitalized when they are a part of a "phrasal
verb", such as "Come On", or "Give Up".

=back

You are supposed to capitalize the word "as" if it is followed by a verb,
and make it lower-case if it is followed by a noun.  This function does not
bother trying to deal with this, since figuring out whether or particular
word is a noun or verb is way beyond the scope of this function.

Also, given a title containing a slash or dash...

=over

=item * "Elvis Presley - A Little Less Conversation"

=item * "Pantera / The Badge"

=back

...the word right before the "slash-or-dash", and the word right after it
are capitalized, since it is assumed that essentially two titles are being
handled on the same line.  This only applies to slashes or dashes
surrounded by whitespace, not hyphens.

Finally, any word containing capital letters other than the first letter
will I<not> be forced to lower-case, since it is assumed that whoever typed
the original phrase is indicating a word with special capitalization.

=head2 Examples:

	$foo = capitalize_title("born in the U.S.A.");
	# $foo is "Born in the U.S.A.",
	#     not "Born in the U.s.a.".

	$foo = capitalize_title("POW");
	# $foo is "POW",
	#     not "Pow".

	$bar = "hey, mr. dJ, i thought you said we had a deal";
	$foo = capitalize_title($bar);
	# $foo is "Hey, Mr. DJ, I Thought You Said We Had a Deal",
	#     not "Hey, Mr. Dj, I Thought You Said We Had a Deal".

=head1 AUTHOR AND COPYRIGHT

Graham Mitchell, 2003-06-10

Released under the terms of the GNU General Public License (GPL), or at
your option, the Artistic License.

=cut

sub capitalize_title($)
{
	my $orig = shift;

	# List of articles, conjunctions, and prepositions shorter than five
	#  letters long.
	my %lclist = (
		'a' => 1, 'an' => 1, 'the' => 1, 'and' => 1, 'but' => 1,
		'or' => 1, 'nor' => 1, 'at' => 1, 'by' => 1, 'for' => 1,
		'from' => 1, 'in' => 1, 'onto' => 1, 'of' => 1, 'off' => 1,
		'on' => 1, 'onto' => 1, 'out' => 1, 'over' => 1, 'to' => 1,
		'up' => 1, 'with' => 1, 'as' => 1,
	);

	# However, short prepositions ARE capitalized if they're a part of a
	#  "phrasal verb"; this is a list of such.
	my @phrasal_verbs = (
		'beat up',
		'blow out',
		'break down',
		'break into',
		'break up',
		'bring up',
		'call off',
		'call on',
		'call up',
		'carry on',
		'come back',
		'come down',
		'come on',
		'come out',
		'come over',
		'do over',
		'fill in',
		'fill out',
		'find out',
		'get by',
		'get on',
		'get over',
		'get it up',
		'get up',
		'give back',
		'give it up',
		'give up',
		'go away',
		'go on',
		'go over',
		'hand in',
		'hang up',
		'hold on',
		'keep on',
		'keep up',
		'leave out',
		'let down',
		'light up',
		'look for',
		'look into',
		'look like',
		'look out',
		'look over',
		'look up',
		'make out',
		'make up',
		'pack up',
		'pass out',
		'pick out',
		'pick up',
		'pour out',
		'put away',
		'put off',
		'put on',
		'put out',
		'put up',
		'rip off',
		'roll over',
		'run into',
		'run out',
		'run over',
		'set it off',
		'show up',
		'take back',
		'take off',
		'take on',
		'take up',
		'talk back',
		'talk over',
		'throw away',
		'try on',
		'turn down',
		'turn in',
		'turn off',
		'turn on',
		'use up',
		'wait on',
	);

	# List of punctuation-type symbols that might occur before or after a
	#  word (with no intervening whitespace).  We'll chop these off the word,
	#  process the word normally, and then stick them back on at the end.
	my %predelims = ( '('=>1, '['=>1, '{'=>1, '"'=>1, '\''=>1, '...'=>1, );
	my %postdelims = ( ')'=>1, ']'=>1, '}'=>1, '"'=>1, '\''=>1, '...'=>1,
		'?'=>1, );

	# Munch whitespace and split up the line into a list of words.
	chomp $orig;
	my @words = split(' ', $orig);
	my $length = @words;

	# Consider each word one at a time.
	my $i;
	for ( $i=0; $i<$length; $i++ )
	{
		# Skip words which contain extra capital letters after the first
		#  character (meaning the data-entry person did some extra
		#  capitalization for us).
		if ( $words[$i] =~ m/^..*[A-Z]/ )
		{
			$words[$i] = ucfirst $words[$i];
			next;
		}

		# Okay, we start by forcing the word to lower-case.
		my $word = lc $words[$i];
		chomp $word; # couldn't hurt to munch trailing whitespace

		# Hack off any punctuation before the word starts...
		my $prefix = '';
		if ( $word =~ m/^(\W+)/ && defined $predelims{$1} )
		{
			$prefix = $1;
			$word =~ s/^\W+//;
		}

		# ...and likewise any trailing punctuation.
		my $suffix = '';
		if ( $word =~ m/(\W+)$/ && defined $postdelims{$1} )
		{
			$suffix = $1;
			$word =~ s/\W+$//;
		}

		# If we're on the first or last word of the title, or if the word
		#  isn't on our list of articles, conjunctions, and short
		#  prepositions, we capitalize it.
		if ( $i == 0  or  $i == $length-1  or  !defined($lclist{$word}) )
		{
			$word = ucfirst $word;
		}

		# If the whole title (as opposed to the current word) contains a
		#  dash or slash, then we basically capitalize the word right
		#  before the dash/slash, and the word right after (since we're
		#  effectively starting over with a second title on the same line).
		if ( ( $i!=0 && ( defined($lclist{$word}) and
			( $words[$i-1] eq '-' or $words[$i-1] eq '/' ) ) )
			or ( $i!=$length-1 && ( defined($lclist{$word}) and
			( $words[$i+1] eq '-' or $words[$i+1] eq '/' ) ) ) )
		{
			$word = ucfirst $word;
		}

		# Check for "phrasal verbs":
		if ( defined($lclist{$word}) )
		{
			my $phrasal;
			foreach $phrasal ( @phrasal_verbs )
			{
				# Skip phrasal verbs not containing the current word.
				next if ( $phrasal !~ m/$word/i );

				my @phrase = split(' ', $phrasal);

				# Skip if the preposition is too close to the beginning of
				#   the title to be a part of this phrase.
				my $word_count = @phrase - 1;
				next if ( $i - $word_count < 0 );

				# Compare the words preceding the preposition to the ones in
				#   the phrasal verb.
				my $match = 1;
				my ( $x, $y );
				for ( $x=$i-$word_count, $y=0; $x<=$i; $x++, $y++ )
				{
					if ( lc $words[$x] ne $phrase[$y] )
					{
						$match = 0;
						last;
					}
				}
				if ( $match == 1 ) # We have a winner....
				{
					$word = ucfirst $word;
					last;
				}
			}

		}

		# Stick prefixes and suffixes back on...
		$word = $prefix . $word if ( $prefix ne '' );
		$word .= $suffix if ( $suffix ne '' );

		# ...and put the word back in the array.
		$words[$i] = $word;
	}

	my $capsword = join(' ', @words);
	return $capsword;
}

1;   # don't forget to return a true value from the file
