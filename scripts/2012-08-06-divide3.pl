
use Test::More;
use Data::Dump;

my @numbers = qw(
    1
    20
    14
    150
    1000
    10000
);

for (@numbers) {
    is log(exp($_) ** 0.33333333333333333333), $_/3, "testing $_";
}

done_testing;
