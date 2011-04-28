
use Test::More;
use List::MoreUtils qw(any none);

my @employees = qw(One Two Three);

ok any  { 'One'  eq $_ } @employees, 'One present';
ok none { 'Four' eq $_ } @employees, 'Four missing';

done_testing;
