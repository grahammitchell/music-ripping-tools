#!/usr/bin/perl -w

use My_Utils::Capitalize_Title;

foreach $line ( <STDIN> )
{
	$word = capitalize_title($line);
	print "$word\n";
}
