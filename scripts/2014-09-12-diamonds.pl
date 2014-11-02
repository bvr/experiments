
use 5.10.0; use strict; use warnings;

for my $i (-1..10) {
    say "$i:";
    draw_diamonds($i, outline => $i>5);
    say "";
}

sub draw_diamonds {
    my ($dim, %opt) = @_;
    my $outline = !! $opt{outline};

    for my $row (1..$dim, reverse 1..$dim-1) {
        say
            " "x($dim-$row)                      # leading spaces
          . "* "                                 # left border
          . ($outline ? "  " : "* ")x($row-2)    # fill
          . ($row > 1 ? "* " : "");              # right border
    }
}

__END__
=head1 Assignment

Given a small positive integer n, write a function that draws a diamond, either
filled or in outline as specified by the user. For instance, here are filled
and outline diamonds for n = 5:

    *              *
   * *            * *
  * * *          *   *
 * * * *        *     *
* * * * *      *       *
 * * * *        *     *
  * * *          *   *
   * *            * *
    *              *

Note that there is a single space between asterisks in the filled version of the diamond.

Your task is to write a program that draws diamonds as described above.
