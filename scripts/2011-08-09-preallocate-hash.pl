
use Benchmark qw(cmpthese);

cmpthese(-4, {
    prealloc => sub {
        my %hash;
        keys(%hash) = 17576;
        $hash{$_} = $_ for 'aaa' .. 'zzz';
    },
    normal   => sub {
        my %hash;
        $hash{$_} = $_ for 'aaa' .. 'zzz';
    },
});

cmpthese(-8, {
    prealloc => sub {
        my %hash;
        keys(%hash) = 456976;
        $hash{$_} = $_ for 'aaaa' .. 'zzzz';
    },
    normal   => sub {
        my %hash;
        $hash{$_} = $_ for 'aaaa' .. 'zzzz';
    },
});

__END__
       Rate   normal prealloc
normal   48.3/s       --      -2%
prealloc 49.4/s       2%       --
        (warning: too few iterations for a reliable count)
     s/iter   normal prealloc
normal     3.62       --      -1%
prealloc   3.57       1%       --
