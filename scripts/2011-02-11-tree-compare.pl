
# from http://stackoverflow.com/questions/4964567/identifying-if-a-trees-are-equal

use Test::More;

my $ex2 = [ 'internal', '+', [ 'leaf', 42], [ 'leaf', 10 ] ];

my $ex3 = [ 'internal', 'average', $ex2, [ 'leaf', 1 ] ];

# ok isEqualShape($ex2, $ex2), 'same';
# ok isEqualShape($ex2, $ex3), 'same';

# ok isEqualStack([],[]), 'same';
# ok isEqualStack([ 'a' ], [ 'a' ]), 'same';
# ok ! isEqualStack([ 'a' ], [ 'b' ]), 'different';
# ok isEqualStack([ [ 'a' ], 'a' ], [ [ 'a' ], 'a' ]), 'same';
ok isEqualShape(
    [ [ 'a' ], 'a' ],
    [ [ 'a' ], 'a' ],
), 'same';

done_testing;

sub isEqualShape {
    my ($x, $y) = @_;

    # same length and node type
    if (@$x == @$y and $x->[0] eq $y->[0]) {

        # same child shape
        for (2 .. $#$x) {
            return unless isEqualShape($x->[$_], $y->[$_]);
        }
        return 1;
    }
    return;
}

sub isEqualStack {
    my @stack = @_;

    while(my ($x,$y) = splice(@stack,0,2)) {
        return unless @$x == @$y and $x->[0] eq $y->[0];

        for (2 .. $#$x) {
            push @stack, ($x->[$_], $y->[$_]);
        }
    }
    return 1;
}
