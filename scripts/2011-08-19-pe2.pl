
# http://projecteuler.net/index.php?section=problems&id=2

use feature 'say';

sub gen_fib {
    my ($a, $b) = (0, 1);
    return sub { (($a, $b) = ($b, $a + $b))[1] }
}

my $it = gen_fib();
my $sum = 0;
while((my $next = $it->()) < 4_000_000)  {
    say $next;
    $sum += $next
        unless $next & 1;
}
say '-'x10;
say $sum;
