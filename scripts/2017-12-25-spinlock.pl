
use 5.16.3;
use Test::More;
use Function::Parameters;
use Data::Dump;

is spinlock_num_after_last(steps => 3),   638,  'Example number';
is spinlock_num_after_last(steps => 366), 1025, 'Example number';


done_testing;

fun spinlock_num_after_last(:$steps, :$times = 2017) {
    my @cb = (0);
    my $pos = 0;
    for my $n (1..$times) {
        my $cb_length = @cb;
        $pos = (($pos + $steps) % $cb_length) + 1;
        splice @cb, $pos, 0, $n;
    }
    return $cb[$pos + 1];
}

=head1 ASSIGNMENT

http://adventofcode.com/2017/day/17

=cut
