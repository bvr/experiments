# Benchmark
use Benchmark qw(:all);

my $count = 10000000;
my $re    = qr/abc/o;
my %tests = (
    "NOFIND        " => "cvxcvidgds.sdfpkisd[s",
    "FIND_AT_END   " => "cvxcvidgds.sdfpabcd[s",
    "FIND_AT_START " => "abccvidgds.sdfpkisd[s",
);

foreach my $type (keys %tests) {
    my $str = $tests{$type};
    cmpthese(
        $count,
        {   "rege1.$type" => sub { my $idx = ($str =~ $re); },
            "rege2.$type" => sub { my $idx = ($str =~ /abc/o); }
        }
    );
}
