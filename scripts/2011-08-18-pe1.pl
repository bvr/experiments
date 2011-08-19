
=head1 Problem 1

If we list all the natural numbers below 10 that are multiples of 3 or 5, we
get 3, 5, 6 and 9. The sum of these multiples is 23.

Find the sum of all the multiples of 3 or 5 below 1000.

L<http://projecteuler.net/index.php?section=problems&id=1>

=cut

use Test::More;
use feature qw(say);

=head1 mathematical approach

Calculates sum of the sequence with n*(n+1)/2 formula.

Sums of multiplies of 3 and 5 are done like this:

 - determine number of items in sequence of 3, 5 and 15 multiplies (15 would counted twice)
 - result is 3*seq3 + 5*seq5 - 15*seq15

=cut

sub sum_seq {
    my $n = shift;
    return $n*($n+1)/2;
}

sub sum_3_5 {
    my $up_to = shift() - 1;
    return
         3*sum_seq(int($up_to/3))
      +  5*sum_seq(int($up_to/5))
      - 15*sum_seq(int($up_to/15));     # LCM(3,5) = 15
}

is sum_3_5(9),    14,     "up to 9:    3,5,6 = 14";
is sum_3_5(10),   23,     "up to 10:   3,5,6,9 = 23";
is sum_3_5(20),   78,     "up to 20:   3,5,6,9,10,12,15,18 = 78";
is sum_3_5(1000), 233168, "up to 1000: 233168";

=head1 generic iterator to produce any multiplies

Makes iterator to produce all sequences of given multiplies, returning lowest
number in each turn. Duplicates are removed.

=cut

use List::Util qw(min);

sub gen_seq {
    my @multi = sort @_;
    my @items = @multi;
    return sub {
        my $min = min(@items);
        for my $i (0..$#items) {
            if($items[$i] == $min) {
                $items[$i] += $multi[$i];
            }
        }
        return $min;
    }
}

my $it = gen_seq(3,5);

# all sums in one pass
my %done;
my %sums = map { $_ => 0 } qw(9 10 20 1000);
while(my $next = $it->()) {

    # all done
    last unless %sums;

    for my $max (keys %sums) {

        # given sum is finished
        if($next >= $max) {
            $done{$max} = $sums{$max};
            delete $sums{$max};
            next;
        }

        $sums{$max} += $next;
    }
}

is_deeply \%done, { 9 => 14, 10 => 23, 20 => 78, 1000 => 233168 }, 'all sums ok';

done_testing;

=head1 Benchmark

The mathematical method is roughly 4 - 100x faster than iterative method.

=cut

use Benchmark qw(cmpthese timethese);

my @targets = qw(9 10 20 1000);
cmpthese(-3, {
    calc => sub {
        for(@targets) {
            my $a1 = sum_3_5($_);
        }
    },
    iter => sub {
        my $it = gen_seq(3,5);

        my %done;
        my %sums = map { $_ => 0 } @targets;
        while(my $next = $it->()) {

            # all done
            last unless %sums;

            for my $max (keys %sums) {

                # given sum is finished
                if($next >= $max) {
                    $done{$max} = $sums{$max};
                    delete $sums{$max};
                    next;
                }

                $sums{$max} += $next;
            }
        }
    },
});
