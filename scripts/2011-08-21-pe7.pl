
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
        if is_prime($cur, \@primes);
    $cur+=2;
}

dd [@primes[0..20]];
say $primes[6 - 1];
say $primes[10_001 - 1];

sub is_prime {
    my ($n,$primes) = @_;
    for(@$primes) {
        return 0 if $n % $_ == 0;
    }
    return 1;
}
