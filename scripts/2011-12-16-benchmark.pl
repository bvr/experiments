use Benchmark qw( timethese cmpthese );
$x = 3;
$r = timethese(
    -5,
    {   a => sub { $x * $x },
        b => sub { $x**2 },
    });
cmpthese $r;
