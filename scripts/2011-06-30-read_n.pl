use 5.010;

open my $fh, '<', '2011-02-19-table-extract.pl' or die $!;

my $lines = read_n_lines($fh, 5);

say @$lines;

sub read_n_lines {
    my ($fh, $n) = @_;

    my @lines = do {
        if   ($n <= 0) { () }
        else           { map scalar <$fh>, 1 .. $n }
    };

    given (wantarray) {
        when (!defined) { return () }
        when (!!$_)     { return @lines}
        default         { return \@lines }
    }
}
