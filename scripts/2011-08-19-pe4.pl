
use feature qw(say);
use Benchmark qw(cmpthese);

# brute force all multiplies
sub simple {
    my $max_palindrome = 0;
    for my $i (reverse 100 .. 999) {
        for my $j (reverse $i .. 999) {
            my $prod = $i * $j;
            $max_palindrome = $prod
                if $prod > $max_palindrome && $prod eq reverse $prod;
        }
    }
    return $max_palindrome;
}

# simple equation, stepping from largest palindrome, checking for divisibility
# 100000*a + 10000*b + 1000*c + 100*c + 10*b + a = m * n
sub equation {
    for my $a (reverse 0..9) {
        for my $b (reverse 0..9) {
            for my $c (reverse 0..9) {
                my $prod = 100_001 * $a + 10_010 * $b + 1_100 * $c;
                for my $div (reverse 100 .. 999) {
                    return $prod
                        if $prod % $div == 0 && $prod/$div < 999;
                }
            }
        }
    }
}

# same equation as above, but with 11 factored out.
# 11 * (9091*a + 910*b + 100*c) = m * n
sub reduced_equation {
    for my $a (reverse 0..9) {
        for my $b (reverse 0..9) {
            for my $c (reverse 0..9) {
                my $num = 9091 * $a + 910 * $b + 100 * $c;
                for my $div (reverse 10 .. 90) {
                    return $num*11
                        if $num%$div == 0 && $num/$div < 999;
                }
            }
        }
    }
}

say simple();
say equation();
say reduced_equation();

cmpthese(-3, {
    simple           => \&simple,
    equation         => \&equation,
    reduced_equation => \&reduced_equation,
});

=head2 Benchmark

                   Rate           simple         equation reduced_equation
simple           7.51/s               --             -90%             -99%
equation         74.0/s             885%               --             -89%
reduced_equation  669/s            8815%             805%               --

=cut
