
use Data::Dump;

my $hash = {
    a => 1,
    b => 2,
    c => 3,
    d => 4,
    e => 5,
};

dd $hash;

dd pick($hash,['a'..'c']);

=head2 pick

    my $picked_hash = pick \%hash, \@keys;

Pick number of items from hashref. It creates new hashref with items whose keys
are specified in keys arrayref.

=cut
sub pick {
    my ($hash, $items) = @_;

    my %new_hash;
    @new_hash{@$items} = @{$hash}{@$items};
    return \%new_hash;
}
