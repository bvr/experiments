
my $example = <<END;
     |
     |  +--+
     A  |  C
 F---|----E|--+
     |  |  |  D
     +B-+  +--+
END

sub build_indexer {
    my ($input) = @_;
    my $area = [ split /\n/, $input ];
    return sub {
        my ($x, $y) = @_;
        return substr($area->[$y], $x, 1);
    };
}

my $index = build_indexer($example);

use Test::More;
use Data::Dump;

is $index->(5,0), '|', 'Entry point';

done_testing;
