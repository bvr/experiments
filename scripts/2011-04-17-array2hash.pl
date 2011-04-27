use strict; use warnings;

my @items = (
    [qw( a1 b1 c1 d1 e1)],
    [qw( a1 b1 c2 d2 e1)],
    [qw( a1 b2 c3)],
);

# SECURITY PROBLEM WITH EVAL
#
# my $dat_hierarchy;
# for my $item (@items) {
#     eval "\$dat_hierarchy->{'" . join("'}{'", @$item) . "'}++";
# }

# BETTER SOLUTION
my $dat_hierarchy = {};
for my $item (@items) {
    my $cx = $dat_hierarchy;
    $cx = $cx->{$_} ||= {}
        for @{$item}[0..$#$item-1];
    $cx->{ $item->[-1] }++;
}

use Data::Dump;
dd $dat_hierarchy;

