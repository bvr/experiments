
use Benchmark qw(:all);

my $a = "Some string";
my @b = map { "Addendum " x $_ } (1..100);

cmpthese(-1, {
    ( map {+ "concat_$_" => sub { my $c = $a . $b[$_] } } (1..10) )
});
