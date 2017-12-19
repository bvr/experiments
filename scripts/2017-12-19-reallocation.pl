
use 5.16.3;
use Test::More;
use List::Util qw(reduce max);
use List::MoreUtils qw(firstidx);

{
    my $banks = [0, 2, 7, 0];
    my ($steps, $redistributed) = reallocations($banks);
    is $steps, 5, 'Initial example';
    is loop_size($redistributed), 4, 'Initial example - part 2';
}

{
    my $banks = [split /\s+/, <DATA>];
    my ($steps, $redistributed) = reallocations($banks);
    is $steps, 14029, 'Input - step 1';
    is loop_size($redistributed), 2765, 'Input - step 2';
}

done_testing;

=head2 reallocations

    my ($steps, $redistributed) = reallocations($banks);

With supplied arrayref of memory bank blocks, realloacates data according
to algorithm below until same configuration is found. Returns number of
reallocations and arrayref of final memory configuration.

=cut

sub reallocations {
    my $banks = [ @{ shift() } ];
    my %seen = ();
    my $steps = 0;
    while(! $seen{ join('-', @$banks) }) {
        $seen{ join '-', @$banks } = 1;
        reallocate($banks);
        $steps++;
    }
    return ($steps, $banks);
}

=head2 loop_size

    my $steps = loop_size($banks);

With supplied arrayref of memory bank blocks, finds how many reallocations
will lead to same memory configuration as supplied.

=cut

sub loop_size {
    my $banks = [ @{ shift() } ];
    my $final = join('-', @$banks);
    my $steps = 1;
    reallocate($banks);
    while(join('-', @$banks) ne $final) {
        reallocate($banks);
        $steps++;
    }
    return $steps;
}

=head2 reallocate

    reallocate($banks);

Distributes first bank with maximum of blocks consequently to following blocks.
Modifies supplied memory bank in place.

=cut

sub reallocate {
    my $banks = shift;
    my $max = max(@$banks);
    my $max_idx = firstidx { $_ == $max } @$banks;
    $banks->[$max_idx] = 0;
    while($max > 0) {
        $max_idx = ($max_idx+1) % @$banks;
        $banks->[$max_idx]++;
        $max--;
    }
}


=head1 ASSIGNMENT

http://adventofcode.com/2017/day/6

--- Day 6: Memory Reallocation ---

A debugger program here is having an issue: it is trying to repair a memory
reallocation routine, but it keeps getting stuck in an infinite loop.

In this area, there are sixteen memory banks; each memory bank can hold any
number of blocks. The goal of the reallocation routine is to balance the blocks
between the memory banks.

The reallocation routine operates in cycles. In each cycle, it finds the memory
bank with the most blocks (ties won by the lowest-numbered memory bank) and
redistributes those blocks among the banks. To do this, it removes all of the
blocks from the selected bank, then moves to the next (by index) memory bank
and inserts one of the blocks. It continues doing this until it runs out of
blocks; if it reaches the last memory bank, it wraps around to the first one.

The debugger would like to know how many redistributions can be done before a
blocks-in-banks configuration is produced that has been seen before.

For example, imagine a scenario with only four memory banks:

  - The banks start with 0, 2, 7, and 0 blocks. The third bank has the most
    blocks, so it is chosen for redistribution.

  - Starting with the next bank (the fourth bank) and then continuing to the
    first bank, the second bank, and so on, the 7 blocks are spread out over the
    memory banks. The fourth, first, and second banks get two blocks each, and the
    third bank gets one back. The final result looks like this: 2 4 1 2.

  - Next, the second bank is chosen because it contains the most blocks (four).
    Because there are four memory banks, each gets one block.
    The result is: 3 1 2 3.

  - Now, there is a tie between the first and fourth memory banks, both of
    which have three blocks. The first bank wins the tie, and its three blocks are
    distributed evenly over the other three banks, leaving it with none: 0 2 3 4.

  - The fourth bank is chosen, and its four blocks are distributed such that
    each of the four banks receives one: 1 3 4 1.

  - The third bank is chosen, and the same thing happens: 2 4 1 2.

At this point, we've reached a state we've seen before: 2 4 1 2 was already
seen. The infinite loop is detected after the fifth block redistribution cycle,
and so the answer in this example is 5.

Given the initial block counts in your puzzle input, how many redistribution
cycles must be completed before a configuration is produced that has been seen
before?

Your puzzle answer was 14029.

--- Part Two ---

Out of curiosity, the debugger would also like to know the size of the loop:
starting from a state that has already been seen, how many block redistribution
cycles must be performed before that same state is seen again?

In the example above, 2 4 1 2 is seen again after four cycles, and so the
answer in that example would be 4.

How many cycles are in the infinite loop that arises from the configuration in
your puzzle input?

Your puzzle answer was 2765.

Both parts of this puzzle are complete! They provide two gold stars: **

=cut

__DATA__
10	3	15	10	5	15	5	15	9	2	5	8	5	2	3	6
