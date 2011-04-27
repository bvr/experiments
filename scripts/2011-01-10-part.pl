
use List::MoreUtils qw(part);
use Data::Dump;

my @list = (1,2,3,4,5,6,7,8,9,10,11);

my $i;
my @part = part { $i++ % 3 } @list;
dd [@part];
