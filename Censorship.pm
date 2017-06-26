package My_Utils::Censorship;

use strict;
use warnings;

BEGIN {
	use Exporter ();
	our ($VERSION, @ISA, @EXPORT);

        # set the version for version checking
        $VERSION     = 1.00;
        @ISA         = qw(Exporter);
        @EXPORT      = qw(&is_dirty &censor);

}

=head1 NAME

functions to determine if a given string contains curse words, or to 
censor those that do.

=head1 SYNOPSIS

	use My_Utils::Censorship;

	foreach $line ( <STDIN> )
	{
		if ( is_dirty($line) )
		{
			$line = censor($line,'XXXX');
		}
		print "$line";
	}

=head1 DESCRIPTION

These functions determine whether or not a given line contains a dirty word.
The dirty words are:
		'ass', 'bitch', 'breast', 'cock', 'cum', 'cunt', 'damn', 'dick',
		'fuck', 'hell', 'piss', 'pussy', 'shit' and 'tit'

These words are also screened through a whitelist, so innocent words
containing these as substrings won't generate a false positive.

The C<is_dirty()> function returns the first dirty word found, or 0 if
nothing was found.

The C<censor()> function take one required parameter and one optional
parameter.  The optional parameter is the string to replace any dirty words
with.  If not supplied, the function will replace the vowels a,e,i,o,u with
asterisks (*).

It censors as many different dirty words as are found on the line.  There is
a possibility that a "clean" word will get censored if it is on the same
line as a dirty word is contains as a substring.  For example,

	censor('Jackie Onassis has nice legs.');

...will return the string unchanged.

	censor('Jackie Onassis has nice fuckin\' legs.');

...will censor the F-word only, but

	censor('Jackie Onassis has a nice ass.');

...with return C<'Jackie On*ssis has a nice *ss.'>, because 'Onassis'
contains 'ass' as a substring.  'Onassis' doesn't trigger the filter, but
the replacement of 'ass' affects 'Onassis', too.  This only happens when the
case matches.

=head1 AUTHOR AND COPYRIGHT

Graham Mitchell, 2003-09-02

Released under the terms of the GNU General Public License (GPL), or at
your option, the Artistic License.

=cut

sub is_dirty($)
{
	my ( $line ) = @_;

	my @bad_wordlist = ();
	my @ok_wordlist = ();

	initwordlist(\@bad_wordlist,\@ok_wordlist);

	my ( $bad, $edited_line, $word, $ok_word );

	$bad = 0;
	$edited_line = $line;
	for $word ( @bad_wordlist )
	{
		if ( $edited_line =~ m/$word/i )
		{
			# maybe bad; let's check it vs the ok_list
			$bad = $&;
			for $ok_word ( @ok_wordlist )
			{
				if ( $edited_line =~ m/$ok_word/i  and  $ok_word =~ m/$word/i )
				{
					$edited_line =~ s/$ok_word/XXXX/ig ;
					if ( $edited_line !~ m/$word/i ) {
						$bad = 0;
					}
				}
			}
			if ( $bad ) {
				return $bad;
				last;	# only report each offending line once
			}
		}
	}
	return 0;
}

sub censor($;$)
{
	my ( $line, $replacement_text ) = @_;
	my ( $word, $sub );

	while ( $word = is_dirty($line) )
	{
		# if they didn't supple replacement text, we'll blank out
		# the vowels of the found word
		if ( ! defined $replacement_text ) {
			$sub = $word;
			$sub =~ s/a/*/ig;
			$sub =~ s/e/*/ig;
			$sub =~ s/i/*/ig;
			$sub =~ s/o/*/ig;
			$sub =~ s/u/*/ig;
		} else {
			$sub = $replacement_text;
		}
		$line =~ s/$word/$sub/;
	}

	return $line;
}

sub initwordlist
{
	my ( $bad_wordlist, $ok_wordlist ) = @_;

	@$bad_wordlist = (
		'ass',
		'bitch',
		'breast',
		'cock',
		'cum',
		'cunt',
		'damn',
		'dick',
		'fuck',
		'hell',
		'piss',
		'pussy',
		'shit',
		'tit',
	);

	@$ok_wordlist = (
		'bass', 'class', 'glass', 'grass', 'brass', 'pass', 'mass',
		'assimilat', 'cassius', 'onassis', 'association', 'morass',
		'assum', 'assail', 'asset', 'assur', 'cassette', 'sassoon',
		'lasso', 'assort', 'assembl', 'assign', 'assert', 'assault',
		'assist', 'carcass', 'associate', 'assassin',
		'cocktail', 'peacock', 'cockpit',
		'circum', 'cucumber', 'scum', 'accumulat', 'document', 'succumb',
		'dickens',
		'hello', 'shell', 'mitchell',
		'pussycat',
		'competiti', 'gratitude', 'multitude', 'titan', 'constitu',
		'title', 'latitude', 'appetite', 'attitude', 'practitioner',
		'petition', 'titter', 'substitut', 'institut', 'stitch', 'quantit',
		'stalactite', 'ineptitude', 'identit',
	);

}

1;   # don't forget to return a true value from the file
