# Graham's Music Ripping Tools

A collection of scripts written in whatever scripting language I was into at
the time. Perl is the oldest, then Ruby, then Python, returning to Bash most
often along the way.

Mostly I use these to rip tracks off one of my *many* CDs and encode each
track into a properly-tagged FLAC. SFW albums were usually then transcoded
into Ogg Vorbis format to play in my classroom at Leander High School.

## Usual workflow

1. Put the CD into the drive.
2. Run ./rip_and_chown.rb
3. While that's going, create a file called `track_info.txt` with the metadata.
4. Run ./wav2tagged_and_renamed_flac.rb
5. If the album is going to school, run ./voter2.sh

The vast majority of these scripts predate `git`, much less `github`.

```
$ ls -lrt

total 276
-rwxr-xr-x 1 mitchell mitchell  527 Jun  5  2003 stripcr.sh
-rwxr-xr-x 1 mitchell mitchell  365 Jun  5  2003 prep.sh
-rwxr-xr-x 1 mitchell mitchell  294 Jun  5  2003 own.sh
-rwxr-xr-x 1 mitchell mitchell 2303 Jun  5  2003 mk_html.pl
-rwxr-xr-x 1 mitchell mitchell 2186 Jun  5  2003 info.pl
-rwxr-xr-x 1 mitchell mitchell 3678 Jun  5  2003 get.pl
-rwxr-xr-x 1 mitchell mitchell  135 Jun 10  2003 titlename.pl
-rwxr-xr-x 1 mitchell mitchell 2581 Jun 11  2003 rename_ogg.pl
-rw-r--r-- 1 mitchell mitchell  208 Jun 18  2003 firstnames
-rw-r--r-- 1 mitchell mitchell 3476 Jun 21  2003 Lexical_Hash.pm
-rwxr-xr-x 1 mitchell mitchell 1404 Jul  9  2003 gentagger.pl
-rw-r--r-- 1 mitchell mitchell  145 Aug  6  2003 wget.url
-rw-r--r-- 1 mitchell mitchell 4237 Sep  2  2003 Censorship.pm
-rwxr-xr-x 1 mitchell mitchell  117 Sep  2  2003 censor
-rw-r--r-- 1 mitchell mitchell  345 Sep  2  2003 cursing-test-corpus.txt
-rwxr-xr-x 1 mitchell mitchell 1016 Sep 16  2003 2to1.sh
-rwxr-xr-x 1 mitchell mitchell  763 Jan  4  2004 submission2lyrics.pl
-rw-r--r-- 1 mitchell mitchell 7527 Apr  3  2004 Capitalize_Title.pm
-rwxr-xr-x 1 mitchell mitchell  211 Jul 11  2004 downsample.sh
-rwxr-xr-x 1 mitchell mitchell  453 Jul 12  2004 22050.sh
-rwxr-xr-x 1 mitchell mitchell  130 Jul 13  2004 name_flac_from_vc.sh
-rwxr-xr-x 1 mitchell mitchell  270 Nov 22  2004 16000.sh
-rwxr-xr-x 1 mitchell mitchell  305 Nov 22  2004 8000.sh
-rwxr-xr-x 1 mitchell mitchell  567 Jun 10  2006 fix_lotsa_dashes.rb
-rwxr-xr-x 1 mitchell mitchell  463 Jun 26  2006 find_superfluous_oggs.rb
-rwxr-xr-x 1 mitchell mitchell 1181 Jul  2  2006 average_bitrate.rb
-rwxr-xr-x 1 mitchell mitchell  143 Aug  9  2006 collate_audiobook.sh
-rwxr-xr-x 1 mitchell mitchell 1310 Aug  9  2006 audiobook.rb
-rwxr-xr-x 1 mitchell mitchell  632 Aug 16  2007 clean_m3u.rb
-rwxr-xr-x 1 mitchell mitchell 2869 Oct 17  2007 fix_pauls_stuff.rb
-rwxr-xr-x 1 mitchell mitchell   81 Jul 28  2008 ucf.pl
-rwxr-xr-x 1 mitchell mitchell 2011 May 19  2011 redo_flac_tags.rb
-rwxr-xr-x 1 mitchell mitchell 1511 Jun  9  2011 txt2lame_opt.pl
-rwxr-xr-x 1 mitchell mitchell   52 Jul 17  2011 rename_mp3s.sh
-rwxr-xr-x 1 mitchell mitchell 1480 Aug  8  2011 oggart
-rwxr-xr-x 1 mitchell mitchell 1580 Aug 11  2011 aacfromflac.sh
-rwxr-xr-x 1 mitchell mitchell  258 Aug 11  2011 aac-multi.sh
-rwxrwxr-x 1 mitchell mitchell 3707 Nov 23  2011 reflac.sh
-rwxrwxr-x 1 mitchell mitchell  161 Feb  9  2012 flac-remove-pictures.sh
drwxr-xr-x 2 mitchell mitchell 4096 Feb  9  2012 old
-rwxrwxr-x 1 mitchell mitchell  754 Feb  9  2012 flac-add-pictures.sh
-rwxrwxr-x 1 mitchell mitchell  108 Feb  9  2012 count-tracks.sh
-rwxr-xr-x 1 mitchell mitchell  820 Mar  6  2012 date-fix.sh
drwxrwxr-x 2 mitchell mitchell 4096 Mar  6  2012 fingerprinting
-rwxr-xr-x 1 mitchell mitchell 1360 Mar  7  2012 asunder-undo.sh
-rwxr-xr-x 1 mitchell mitchell 1358 Mar 23  2012 abcde-undo.sh
-rwxr-xr-x 1 mitchell mitchell  396 Apr  8  2012 number_flacs.sh
-rwxr-xr-x 1 mitchell mitchell  692 Jul  4  2012 number_oggs.sh
-rwxr-xr-x 1 mitchell mitchell 2283 Oct 23  2012 voter.sh
-rwxr-xr-x 1 mitchell mitchell 1032 Oct 25  2012 utils.rb
-rwxr-xr-x 1 mitchell mitchell 2254 Oct 25  2012 phone.sh
-rwxr-xr-x 1 mitchell mitchell  625 Nov  1  2012 mp3fromflac.sh
-rwxr-xr-x 1 mitchell mitchell  432 Nov  1  2012 number_mp3s.sh
-rwxr-xr-x 1 mitchell mitchell  506 Nov  1  2012 amazon-prep.sh
-rwxr-xr-x 1 mitchell mitchell 1806 Nov 12  2012 tagsort.rb
-rwxr-xr-x 1 mitchell mitchell  194 Nov 13  2012 disc-1.sh
-rwxr-xr-x 1 mitchell mitchell  194 Nov 13  2012 disc-2.sh
-rwxrwxr-x 1 mitchell mitchell 1103 Nov 14  2012 playlist_from_flacs.sh
-rwxrwxr-x 1 mitchell mitchell  588 Nov 15  2012 artist_tag.sh
-rwxrwxr-x 1 mitchell mitchell  910 Nov 15  2012 playlist_flac2ogg.sh
-rwxr-xr-x 1 mitchell mitchell 2924 Nov 27  2012 wav2tagged_and_renamed_flac.rb
-rwxrwxr-x 1 mitchell mitchell  368 Nov 27  2012 tag-flacs-again.sh
-rwxr-xr-x 1 mitchell mitchell 1186 Jun 24  2015 rip_and_chown.rb
-rwxrwxr-x 1 mitchell mitchell  313 Jul 23  2016 yearify_albums.sh
-rwxr-xr-x 1 mitchell mitchell 1167 Aug  6  2016 what-undo.sh
-rwxr-xr-x 1 mitchell mitchell 1950 Feb 10 10:52 retag.rb
-rwxr-xr-x 1 mitchell mitchell 4257 Mar 28 22:45 voter2.sh
-rw-r--r-- 1 mitchell mitchell  763 Jun 25 19:01 README.md
```

Cheers,

-Graham
