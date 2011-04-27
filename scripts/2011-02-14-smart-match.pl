
# http://stackoverflow.com/questions/4987795/perl-pattern-match-array

use warnings;
use strict;
use autodie; # open and close will now die on failure
use 5.10.1;
use Data::Dump;


my @patterns = (
  qr"^exact",
  qr"^T.?:",
  "",
  "exact",
);

my $result;

open my $fh, '<', 'example.txt';

while ( my $line = <$fh> ) {
  chomp $line;
  $result = $line ~~ @patterns;
  dd $result;
}
close($fh);

