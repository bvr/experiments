
use List::MoreUtils qw(uniq);

my %c1 = ( "Function-A" => 1, "Function-B" => 1, );
my %c2 = ( "Function-A" => 1, "Function-B" => 1, );

my @keys = sort +uniq keys(%c1), keys(%c2);

use Data::Dump;
dd @keys;

use Benchmark qw(cmpthese);
use List::Util qw(shuffle);

# 10_000 items ~ 50% same
my @items = shuffle((1 .. 10_000) x 2);

cmpthese(-2, {
    sort_uniq => sub {
        my @result = sort +uniq @items;
    },
    uniq_sort => sub {
        my @result = uniq sort @items;
    },
});

