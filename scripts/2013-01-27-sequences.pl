
use List::Util 'reduce';
use Data::Dump 'pp';

sequences(0);
sequences(0,1,2, 4,5,6,7, 9);

sub sequences {
    my @seq = @_;
    my $out = [[]];
    reduce {
        $a->[-1][-1] + 1 == $b
            ? push @{$a->[-1]}, $b
            : push @$a, [$b]; $a
        } $out, sort @seq;
    shift @$out;

    warn pp(\@seq). " => " . pp($out) . "\n";       # FIXME: debug

    return $out;
}
