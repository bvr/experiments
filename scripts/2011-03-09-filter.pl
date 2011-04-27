
my @v1 = (1,2,3,4,5);
my @filter = qw(1 0 0 1 1);

use Data::Dump;
dd map { $filter[$_] ? $_[$_] : () } 0..$#_;
