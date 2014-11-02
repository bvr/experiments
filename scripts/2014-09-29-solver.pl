
use 5.10.1;
use Test::More;

my @variants = (
    [   1,   1   => 1    ],
    [   2,   2   => 2    ],
    [   2,   6   => 4    ],
    [   2,  65   => 23   ],
    [ 257,   1   => 257  ],
    [ 257,   6   => 259  ],
    [ 257, 384   => 385  ],
    [ 924,   1   => 924  ],
    [ 924,   6   => 926  ],
    [ 924, 971   => 1247 ],
);

for my $v (@variants) {
    my ($x, $y, $expected) = @$v;
    is +($x+int($y/3)), $expected, sprintf "test %4d %4d = %4d", $x, $y, $expected;
}

done_testing;
