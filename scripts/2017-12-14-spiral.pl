
use Test::More;
use Data::Dump;

is man_dist(1),      0;
is man_dist(12),     3;
is man_dist(23),     2;
is man_dist(1024),   31;
is man_dist(4),      1;
is man_dist(14),     3;
is man_dist(15),     2;
is man_dist(16),     3;
is man_dist(17),     4;
is man_dist(18),     3;
is man_dist(19),     2;
is man_dist(20),     3;
is man_dist(21),     4;
is man_dist(22),     3;
is man_dist(23),     2;
is man_dist(24),     3;
is man_dist(25),     4;
is man_dist(347991), 480;

use Iterator::Simple qw(iterator);

=head2 dir_and_steps

    my $ds_iter = dir_and_steps();
    ($dir, $steps) = $ds_iter->next;

Produce direction (0..3) and number of steps to make to form a spiral.

=cut

sub dir_and_steps {
    my ($dir, $steps, $i) = (0, 0, 1);

    iterator {
        return ($dir++%4, $steps += ($i++%2));
    }
}


=head2 spiral_memory

    my $sm_iter = spiral_memory();
    ($value, $x, $y) = $sm_iter->next;

Produce values in the spiral along with the value location. Starting location
is on (0,0) and value 1, moving left and up first, forming the spiral:

    17  16  15  14  13
    18   5   4   3  12
    19   6   1   2  11
    20   7   8   9  10
    21  22  23---> ...

=cut

sub spiral_memory {
    my ($value, $x, $y) = (1, 0, 0);
    my $step = 0;

    my $das = dir_and_steps();
    my ($dir, $steps) = $das->next;
    my @dirs = (
        [ 1,  0],       # left
        [ 0,  1],       # up
        [-1,  0],       # right
        [ 0, -1],       # down
    );

    iterator {
        my $rv = [$value, $x, $y];

        # calculate the next value
        $value++;

        # move in current direction
        $x += $dirs[$dir][0];
        $y += $dirs[$dir][1];

        # after number of steps, new direction and step count
        if(++$step == $steps) {
            $step = 0;
            ($dir, $steps) = $das->next;
        }

        return @$rv;
    }
}


=head2 man_dist

    $dist = man_dist(126);

Calculates shortest distance to center of the spiral from item of parameter value.

=cut

sub man_dist {
    my $target = shift;

    my $locations = spiral_memory();
    while(my ($value, $x, $y) = $locations->next) {
        return abs($x) + abs($y)
            if $value >= $target;
    }
}


=head2 man_dist

    $dist = man_dist(126);

Calculates shortest distance to center of the spiral from item of parameter value.
This is the method we built with Ondra on last Thursday.

=cut

sub man_dist_old {
    my $target = shift;

    my $i = 1;
    my $inc = 0;
    while($target > $i) {
        $inc++;
        $i += $inc;
        $i += $inc;
        # dd $inc, $i, $target;
    }
    my $run_over = $i - $target;
    if($inc % 2 == 0) {
        if($run_over > $inc) {
            # up
            $run_over -= $inc;
            return abs($run_over - $inc/2) + $inc/2
        }
        else {
            # left
            return abs($run_over - $inc/2) + $inc/2
        }
    }
    else {
        if($run_over > $inc) {
            # down
            $run_over -= $inc;
            return abs($run_over - int(($inc+1)/2)) + int($inc/2)
        }
        else {
            # right
            return abs($run_over - int(($inc+1)/2)) + int(($inc+1)/2)
        }
    }
}

done_testing;


=head1 ASSIGNMENT

--- Day 3: Spiral Memory ---

You come across an experimental new kind of memory stored on an infinite two-dimensional grid.

Each square on the grid is allocated in a spiral pattern starting at a location marked 1 and then counting up while spiraling outward. For example, the first few squares are allocated like this:

17  16  15  14  13
18   5   4   3  12
19   6   1   2  11
20   7   8   9  10
21  22  23---> ...

While this is very space-efficient (no squares are skipped), requested data must be carried back to square 1 (the location of the only access port for this memory system) by programs that can only move up, down, left, or right. They always take the shortest path: the Manhattan Distance between the location of the data and square 1.

For example:

    Data from square 1 is carried 0 steps, since it's at the access port.
    Data from square 12 is carried 3 steps, such as: down, left, left.
    Data from square 23 is carried only 2 steps: up twice.
    Data from square 1024 must be carried 31 steps.

How many steps are required to carry the data from the square identified in your puzzle input all the way to the access port?

Your puzzle input is 347991.

Your puzzle answer was 480.

--- Part Two ---

As a stress test on the system, the programs here clear the grid and then store the value 1 in square 1. Then, in the same allocation order as shown above, they store the sum of the values in all adjacent squares, including diagonals.

So, the first few squares' values are chosen as follows:

    Square 1 starts with the value 1.
    Square 2 has only one adjacent filled square (with value 1), so it also stores 1.
    Square 3 has both of the above squares as neighbors and stores the sum of their values, 2.
    Square 4 has all three of the aforementioned squares as neighbors and stores the sum of their values, 4.
    Square 5 only has the first and fourth squares as neighbors, so it gets the value 5.

Once a square is written, its value does not change. Therefore, the first few squares would receive the following values:

147  142  133  122   59
304    5    4    2   57
330   10    1    1   54
351   11   23   25   26
362  747  806--->   ...

What is the first value written that is larger than your puzzle input?

Your puzzle input is still 347991.

=cut
