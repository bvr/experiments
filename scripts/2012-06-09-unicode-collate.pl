use 5.010;
use utf8::all;
use Unicode::Collate;

my $coll = Unicode::Collate->new(level => 1);

say for map { $_->[1] }
    sort { $a->[0] cmp $b->[0] }
    map { [$coll->getSortKey($_), $_] }
    qw(
        Hubáček
        Archibald
        Áron
        Cigán
        caga
        Čeněk
    );
