
use Data::Dump;

sub factors {
    my $n = shift;
    my $f = 2;
    my @ret = ();
    while($n > 1) {
        while($n%$f == 0) {
            push @ret, $f;
            $n /= $f;
        }
        $f++;
    }
    return @ret;
}

dd factors(13195);
dd factors(600851475143);

print 71 * 839 * 1471 * 6857;
