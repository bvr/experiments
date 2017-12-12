
=head1 BRAIN TEASER

Find a six-digit number containing no zeros and no repeated digits that
satisfies the following conditions:

 1. The first and fourth digits sum to the last digit, as do the third and fifth digits.
 2. The first and second digits when read as a two-digit number equal one quarter the fourth and fifth digits.
 3. The last digit is four times the third digit.

=head1 RESULT

192768

=cut

use 5.16.3;
use Algorithm::Combinatorics qw(variations);

my $iter = variations([1..9], 6);
while(my $p = $iter->next) {
    my ($a, $b, $c, $d, $e, $f) = @$p;
    next unless $a + $d == $f;
    next unless $c + $e == $f;
    next unless 10*$a+$b == (10*$d+$e)/4;
    next unless $f == 4*$c;

    say join '',@$p;
}
