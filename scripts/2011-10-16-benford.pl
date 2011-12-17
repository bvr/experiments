
use strict; use warnings;
use Data::Dump;
use Math::Random qw(random_normal);

my %dist;
for my $n (1..9_999) {
    $dist{ substr(random_normal(1, 5_000, 2_000),0,1) }++;
}

dd \%dist;

# benford's law does not conform to normal distribution
