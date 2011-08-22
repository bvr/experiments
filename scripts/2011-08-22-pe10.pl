
=head1 Problem 10

The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.

Find the sum of all the primes below two million.

L<http://projecteuler.net/index.php?section=problems&id=10>

=cut

use 5.010;

use constant MAX_PRIME => 2_000_000;

sub naive {
    my $sum = 2;
    my $cur = 3;
    while($cur < MAX_PRIME) {
        $sum += $cur if is_prime($cur);
        $cur += 2;
    }
    return $sum;
}

sub eratosthenes {
    my $image;
    vec($image,MAX_PRIME,1) = 0;        # allocate string ~ 250k
    my $sum = 2;
    my $cur = 3;
    while($cur < MAX_PRIME) {
        if(vec($image,$cur,1) == 0) {
            for(my $i = $cur; $i < MAX_PRIME; $i += $cur) {
                vec($image,$i,1) = 1;
            }
            $sum += $cur;
        }
        $cur += 2;
    }
    return $sum;
}

# eratosthenes allocating only even numbers
sub eratosthenes2 {
    my $image;
    my $last_index = (MAX_PRIME-1) >> 1;
    vec($image,$last_index,1) = 0;        # allocate string ~ 125k

    my $crosslimit = int(sqrt(MAX_PRIME) - 1) >> 1;
    for my $i (1 .. $crosslimit) {
        if(vec($image,$i,1) == 0) {       # 2*i+1 is prime, mark multiples
            for(my $j = 2*$i*($i+1); $j <= $last_index; $j += 2*$i+1) {
                vec($image,$j,1) = 1;
            }
        }
    }

    my $sum = 2;        # 2 is prime
    for my $i (1 .. $last_index) {
        $sum += 2*$i+1  if vec($image,$i,1) == 0;
    }

    return $sum;
}

say naive();            # cca 13.0s
say eratosthenes();     # cca  2.4s, about 4x faster
say eratosthenes2();    # cca  1.1s, about 2x faster than eratosthenes

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
