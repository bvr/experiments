
use 5.16.3;
use List::MoreUtils qw(part);
use Data::Dump;


my @values = qw(one two three four five six);
my %values_lookup = map { $_ => 1 } qw(one three six);

my ($in_lookup, $new_ones) = part { defined $values_lookup{$_} ? 0 : 1 } @values;

dd { in_lookup => $in_lookup, new_ones => $new_ones };
