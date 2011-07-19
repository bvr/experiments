use warnings; use strict;
use Data::Dumper;

my $group = [ qw(a b c d e) ];

my $subset1 = make_subset($group, 3);
my $subset2 = make_subset($subset1, 1);

print Dumper($subset1, $subset2);

sub make_subset {
    my ($ary, $max_elements) = @_;

    return [ @$ary ] if $max_elements > @$ary;
    return [ @$ary[0 .. --$max_elements] ];
}

