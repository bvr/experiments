
use 5.10.1; use strict; use warnings;
use List::Util 'reduce';
use Data::Dump 'dd';

my @revs = ();
while(<DATA>) {
    /Revision: (\d+)/ && push @revs, $1;
}
say "[" . join(",", join_sequences("-", sort { $a <=> $b } @revs)) . "]";

sub join_sequences {
    my ($sep, @list) = @_;

    my $grouped = reduce {
        if($a->[-1][-1]+1 == $b) { push @{$a->[-1]}, $b }
        else                     { push @$a, [$b]       }
        $a
    } [[$list[0]]], @list[1..$#list];

    return map { @$_ <= 1 ? $_->[0] : join($sep, $_->[0], $_->[-1]) } @$grouped;
}

__DATA__
Revision: 170
Revision: 167
Revision: 166
Revision: 164
Revision: 163
Revision: 162
Revision: 161
