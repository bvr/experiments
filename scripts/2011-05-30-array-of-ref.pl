my @array = \( my ($a,$b,$c) = (1,2,3));

use Data::Dump;
dd \@array;

$a = 5;

dd \@array;
