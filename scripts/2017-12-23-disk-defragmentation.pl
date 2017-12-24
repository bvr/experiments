
use 5.16.3;
use Test::More;
use Function::Parameters;
use Data::Dump;
use List::AllUtils qw(natatime reduce sum);

my $key_string = 'jxqlasbh';

my $num_bits = 0;
for my $row (0..127) {
    $num_bits += count_bits(knot_hash($key_string.'-'.$row));
}
is $num_bits, 8140, 'Number of bits - part 1';

my @matrix = ();
for my $row (0..127) {
    my $hash = knot_hash($key_string.'-'.$row);
    push @matrix, [ split //, join '', map { sprintf "%04b", hex($_) } split //, $hash ];
}
# dd @matrix;

# color first row
my $group = 2;
for my $y (0..127) {
    for my $x (0..127) {
        if(color_regions(matrix => \@matrix, x => $x, y => $y, group => $group)) {
            $group++;
        }
    }
}
is $group-2, 1184, 'Number of groups in the disk - part 2';

done_testing;


fun color_regions(:$matrix, :$x, :$y, :$group = 2) {
    return if $x < 0 || $y < 0 || $x > 127 || $y > 127;     # outside of bounds
    return if $matrix->[$x][$y] != 1;                       # not a region for coloring

    $matrix->[$x][$y] = $group;

    color_regions(matrix => $matrix, x => $x - 1, y => $y,     group => $group);
    color_regions(matrix => $matrix, x => $x,     y => $y - 1, group => $group);
    color_regions(matrix => $matrix, x => $x + 1, y => $y,     group => $group);
    color_regions(matrix => $matrix, x => $x,     y => $y + 1, group => $group);

    return 1;
}

fun count_bits($hex_string) {
    state $hex_digit_bits = {
        map {
            my $hexdigit = $_;
            $hexdigit => (sum map { hex($hexdigit)&$_ ? 1 : 0 } (1,2,4,8))
        } ('0' .. '9', 'a' .. 'f')
    };
    return sum map { $hex_digit_bits->{$_} } split //, $hex_string;
}

fun knot_hash($str) {
    return dense_hash(knot_hash_rotations(list => [0..255], lengths => lengths_from_string($str), rounds => 64));
}

fun dense_hash($array) {
    my $it = natatime 16, @$array;
    my @dense;
    while(my @vals = $it->()) {
        push @dense, reduce { $a ^ $b } @vals;
    }
    return sprintf "%02x"x16, @dense;
}

fun knot_hash_rotations(:$list, :$lengths, :$rounds = 1) {
    my $cp = 0;
    my $skip = 0;
    for my $round (1..$rounds) {
        for my $len (@$lengths) {
            for my $i (0 .. int($len/2) - 1) {
                my $i1 = ($cp + $i) % @$list;
                my $i2 = ($cp + $len - $i - 1) % @$list;
                ($list->[$i1], $list->[$i2]) = ($list->[$i2], $list->[$i1]);
            }
            $cp += $len + $skip;
            $skip++;
        }
    }

    return $list;
}

fun lengths_from_string($str) {
    my @chars = map { ord } split //, $str;
    return [ @chars, 17, 31, 73, 47, 23 ];
}


=head1 ASSIGNMENT

http://adventofcode.com/2017/day/14

=head2 --- Day 14: Disk Defragmentation ---

Suddenly, a scheduled job activates the system's disk defragmenter. Were the
situation different, you might sit and watch it for a while, but today, you
just don't have that kind of time. It's soaking up valuable system resources
that are needed elsewhere, and so the only option is to help it finish its task
as soon as possible.

The disk in question consists of a 128x128 grid; each square of the grid is
either free or used. On this disk, the state of the grid is tracked by the bits
in a sequence of knot hashes.

A total of 128 knot hashes are calculated, each corresponding to a single row
in the grid; each hash contains 128 bits which correspond to individual grid
squares. Each bit of a hash indicates whether that square is free (0) or
used (1).

The hash inputs are a key string (your puzzle input), a dash, and a number from
0 to 127 corresponding to the row. For example, if your key string were
flqrgnkx, then the first row would be given by the bits of the knot hash of
flqrgnkx-0, the second row from the bits of the knot hash of flqrgnkx-1, and so
on until the last row, flqrgnkx-127.

The output of a knot hash is traditionally represented by 32 hexadecimal
digits; each of these digits correspond to 4 bits, for a total of 4 * 32 = 128
bits. To convert to bits, turn each hexadecimal digit to its equivalent binary
value, high-bit first: 0 becomes 0000, 1 becomes 0001, e becomes 1110, f
becomes 1111, and so on; a hash that begins with a0c2017... in hexadecimal
would begin with 10100000110000100000000101110000... in binary.

Continuing this process, the first 8 rows and columns for key flqrgnkx appear
as follows, using # to denote used squares, and . to denote free ones:

    ##.#.#..-->
    .#.#.#.#
    ....#.#.
    #.#.##.#
    .##.#...
    ##..#..#
    .#...#..
    ##.#.##.-->
    |      |
    V      V

In this example, 8108 squares are used across the entire 128x128 grid.

Given your actual key string, how many squares are used?

Your puzzle answer was 8140.

=head2 --- Part Two ---

Now, all the defragmenter needs to know is the number of regions. A region is a
group of used squares that are all adjacent, not including diagonals. Every
used square is in exactly one region: lone used squares form their own isolated
regions, while several adjacent squares all count as a single region.

In the example above, the following nine regions are visible, each marked with
a distinct digit:

    11.2.3..-->
    .1.2.3.4
    ....5.6.
    7.8.55.9
    .88.5...
    88..5..8
    .8...8..
    88.8.88.-->
    |      |
    V      V

Of particular interest is the region marked 8; while it does not appear
contiguous in this small view, all of the squares marked 8 are connected when
considering the whole 128x128 grid. In total, in this example, 1242 regions are
present.

How many regions are present given your key string?

Your puzzle answer was 1182.

Both parts of this puzzle are complete! They provide two gold stars: **

=cut
