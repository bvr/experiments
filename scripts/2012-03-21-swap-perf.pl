
use Benchmark qw(cmpthese);
use Data::Alias;

my @array = ('thing', 'stuff', 'that', 'joe'x10000, 'sofa', 'jim'x10000);
cmpthese(-2, {
    slice => sub {
        @array[3,5] = @array[5,3];
    },
    temp  => sub {
        my $tmp = $array[3];
        $array[3] = $array[5];
        $array[5] = $tmp;
    },
    alias => sub {
        alias @array[3,5] = @array[5,3];
    }
});
