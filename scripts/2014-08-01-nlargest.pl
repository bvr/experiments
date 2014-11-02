use strict;
use warnings;

my $k = shift @ARGV;

my @nos = ();
foreach my $i (1..$k) {
  my $l = <>;
  $l*=1;
  push @nos, $l;
}
@nos = sort { $b<=>$a } @nos;

while(<>) {
  $_*=1;
  next if $_ < $nos[$k-1];
  foreach my $i (0..($k-1)) {
    next unless $_ > $nos[$i];
    splice @nos,$i,0,$_;
    pop @nos;
    last;
  }
}

print "$nos[$k-1]\n";
