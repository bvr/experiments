
use List::Util 'reduce';
use Test::More;
use Test::Fatal;

ok ! exception { is_increasing(1..10) }, 'increasing';
ok   exception { is_increasing(1,2,1,3) }, 'not increasing';

done_testing;

sub is_increasing {
    reduce { $a >= $b ? die "not increasing: $a >= $b" : $b } @_;
}

