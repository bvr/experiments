
use strict; use warnings;

my @items = (
    [qw( a1 b1 c1 d1 e1)],
    [qw( a1 b1 c2 d2 e1)],
    [qw( a1 b2 c3)],
);

my $dat_hierarchy;
for my $item (@items) {
    eval "\$dat_hierarchy->{'" . join("'}{'", @$item) . "'}++";
}

use Data::Dump;
dd $dat_hierarchy;
