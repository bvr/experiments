 use strict;
 use warnings;
 use Encode;
 use 5.010;
 use utf8;
 use autodie;
 use warnings    qw< FATAL  utf8     >;
 use open        qw< :std  :utf8     >;
 use feature     qw< unicode_strings >;
 use warnings 'all';

 use Win32::Unicode::Native;

 binmode STDOUT, ':utf8';   # output should be in UTF-8
 my $word;
 my @array = ( 'אני רוצה לישון', 'Intermediary',
    'היא רוצה לישון', 'אתם, הם', 'Bye','Hello, world!', 'test');
 foreach $word(@array) {
    say $word;
 }

