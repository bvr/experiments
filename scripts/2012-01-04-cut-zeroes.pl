
use Test::More;
use List::MoreUtils qw(natatime);

my @tests = qw(
    0e0          0
    -.0          0
    0000.0001    0.0001
    1.20e-06     1.2E-6
    -0010.0010   -10.001
    1.00011000   1.00011
    +1           1
    -2           -2
    -2.10        -2.1
    1E10         1E10
    1E0010       1E10
    1E-050       1E-50
    -.10         -0.1
    10.00        10
);

my $it = natatime 2, @tests;

while(my ($in, $out) = $it->()) {
    if(my ($sign, $whole, $dec, $exp) = $in =~ m{
        ^\s*
        ([+-]?)             # sign
        (\d*)               # whole
        (\.\d+)?            # decimal
        ([eE][+-]?\d+)?     # exponent
        \s*$
        }x
    ) {
        $whole =~ s/^0+//;
        $whole = 0 if $whole eq '';

        $dec   =~ s/0+$//;
        $dec   = '' if $dec eq '.';

        $exp   =~ s/e/E/i;
        $exp   =~ s/E[+]/E/;
        $exp   =~ s/(E[-]?)0+/${1}/;
        $exp   = '' if $exp eq 'E';

        $sign  = '' if $sign eq '+' || "$whole$dec$exp" eq '0';

        is "$sign$whole$dec$exp", $out, "$in -> $sign$whole$dec$exp";
    }
    else {
        ok 0, "$in did not match";
    }
}

done_testing;
