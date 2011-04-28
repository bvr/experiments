# from http://perlmonks.org/index.pl?node_id=857338
# nice use of unpack

use List::MoreUtils qw(natatime);

# the string is: 4B length 1B type nB value of length ... repeated

my $it = natatime 2,
    unpack "(x4 A X5 A4x/A)*", '0004$ADAM0002*330004%19770004$BOB 0002*430004%1967';
print "type = $type   value = $val\n" while ($type,$val) = $it->();
