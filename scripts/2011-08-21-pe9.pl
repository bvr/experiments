
=head1 Problem 9

A Pythagorean triplet is a set of three natural numbers, a  b  c, for which,

    a2 + b2 = c2

For example, 32 + 42 = 9 + 16 = 25 = 52.

There exists exactly one Pythagorean triplet for which a + b + c = 1000.
Find the product abc.

=cut

use 5.010;

my $s = 1000;
for my $a (1 .. $s-1) {
    my $b = (-$s**2/2 + $s*$a)/($a - $s);
    my $c = $s - $a - $b;
    if($b == int($b) && $a < $b && $b < $c && $a**2+$b**2 == $c**2) {
        say $a, " * ", $b, " * ", $c, " = ", $a*$b*$c;
    }
}
