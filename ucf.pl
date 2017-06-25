#!/usr/bin/perl -w

while( <> )
{
	print join(' ', map(ucfirst, split)), "\n";
}
