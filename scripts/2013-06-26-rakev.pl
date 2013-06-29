
=head1 INPUT

     LORD
     KORD
     MORD
    -----
    RAKEV

What are the numbers?

=cut

use 5.12.0; use strict; use warnings;
use Algorithm::Combinatorics qw(variations);

my $found = 0;
my $it = variations([0..9], 9);
while(my $set = $it->next) {
    my ($D, $R, $O, $L, $K, $M, $V, $E, $A) = @$set;
    print(" $L$O$R$D\n $K$O$R$D\n $M$O$R$D\n-----\n$R$A$K$E$V\n\n") && $found++
        if     $L > 0
            && $K > 0
            && $M > 0
            && $R > 0
            &&                1000*($L+$K+$M) + 300*$O + 30*$R + 3*$D
                == 10000*$R + 1000*$A         + 100*$K + 10*$E +   $V;
}
say "Found: $found solutions";
