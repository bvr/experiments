
use Test::More;

my $re = qr/
    ^
    (   [-]? [0-9]* (\.[0-9]+)? ([eE][+-]?[0-9]+)?
    |   0[xX][0-9a-fA-F]+
    |   0[bB][01]+
    )
    $
/x;

my @match = (
    '',
    '0',
    '-0',
    '-2',
    '20',
    '-5.1',
    '6.045',
    '-9.2e1',
    '10e-5',
    '5E+200',
    '0x00',
    '0XDEAD',
    '0b10101',
    '0B00010',
);

my @fails = (
    'aa',
    '10b',
    '0x1G2',
);

ok(/$re/,  "\"$_\" matches") for @match;
ok(!/$re/, "\"$_\" fails")   for @fails;

done_testing;
