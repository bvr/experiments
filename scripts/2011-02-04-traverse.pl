
my @nodes = (
    {   name => 'ARINC_TEST',
        file => 'powrup.asm',
        line => 633,
        children => [
            {   name => 'ARINC_LEVEL_TEST',
                file => 'artest.asm',
                line => 178,
                children => [
                    { name => 'AD_READ', file => 'arltst.asm', line => 204 },
                    { name => 'AD_READ', file => 'arltst.asm', line => 250 },
                    { name => 'AD_READ', file => 'arltst.asm', line => 300 },
                    { name => 'AD_READ', file => 'arltst.asm', line => 346 },
                    { name => 'AD_READ', file => 'arltst.asm', line => 396 },
                    { name => 'AD_READ', file => 'arltst.asm', line => 442 },
                ],
            },
            {   name => 'ARINC_READ',
                file => 'artest.asm',
                line => 209,
                children => [],
            },
            {   name => 'ARINC_WORD_TXRX_TEST',
                file => 'artest.asm',
                line => 221,
                children => [
                    { name => 'ARINC_OUT',  file => 'artxrx.asm', line => 207 },
                    { name => 'ARINC_READ', file => 'artxrx.asm', line => 221 },
                ],
            }
        ]
    }
);

use Data::Dump qw{dump};
dump [@nodes];

for my $node (@nodes) {
    print_node($node, 1);
}

sub print_node {
    my ($node, $level) = @_;

    print "." x ($level*6)
        , $node->{name}, " " x 4
        , $node->{file}, ":"
        , $node->{line}, "\n";
    if(defined $node->{children}) {
        for my $child (@{ $node->{children} }) {
            print_node($child, $level + 1);
        }
    }
}
