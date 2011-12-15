
use Benchmark ':all';

my $count   = 0;
my @strings = (
    "i'm going to find the occurrence of two words going if possible",
    "i'm going to find the occurrence of two words if impossible",
    "to find a solution to this problem",
    "i will try my best for a way to match this problem"
);
@neurot = qw(going match possible);
my $com_neu = '\b' . join('\b|\b', @neurot) . '\b';

my %neurot_hash = map { $_ => 1 } @neurot;

sub out {
    # print @_
}

cmpthese(-2, {
    method1 => sub {
        $count = 0;
        foreach my $sentence (@strings) {
            @l = $sentence =~ /($com_neu)/gi;
            foreach my $list (@l) {
                if ($list =~ m/\w['\w-]*/) {
                    out $list," ";
                }
            }
            out "\n";
        }
    },
    method2 => sub {
        $count = 0;
        foreach my $sentence (@strings) {
            for my $found (grep { $neurot_hash{ lc $_} } $sentence =~ /\w['\w-]*/gi) {
                out $found," ";
            }
            out "\n";
        }
    },
});
