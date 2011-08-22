
=head1 Problem 7

By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, we can see that
the 6th prime is 13.

What is the 10 001st prime number?

=cut

use feature 'say';
use Data::Dump;

my @primes = (2);

my $cur = 3;
while(@primes <= 10_001) {
    push @primes, $cur
        if is_prime($cur);
    $cur+=2;
}

dd [@primes[0..20]];
say $primes[6 - 1];
say $primes[10_001 - 1];

sub is_prime_naive {
    my ($n,$primes) = @_;
    for(@$primes) {
        return 0 if $n % $_ == 0;
    }
    return 1;
}

# from projecteuler.net 007_overview.pdf
sub is_prime {
    my $n = shift;

    return 0 if $n == 1;
    return 1 if $n < 4;        # 2 and 3 are prime
    return 0 if $n % 2 == 0;
    return 1 if $n < 9;        # we have already excluded 4,6 and 8.
    return 0 if $n % 3 == 0;

    # n rounded to the greatest integer r so that r*r<=n
    my $r = int(sqrt($n));
    my $f = 5;
    while ($f <= $r) {
        return 0 if $n % $f == 0;
        return 0 if $n % ($f + 2) == 0;
        $f += 6;
    }
    return 1              # in all other cases
}
