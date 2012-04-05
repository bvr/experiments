
use 5.010;
use List::MoreUtils qw(each_arrayref);

my @a = qw(ahoj nazdar cau);

my $iter = each_arrayref([0..$#a], \@a);
while(my ($i, $it) = $iter->()) {
    say "[$i] $it";
}
