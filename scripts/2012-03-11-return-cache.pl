
package Item;
use Moose;

sub cached {
    my ($self, $cache_key, $cb) = @_;

    if(defined(my $data = $self->{$cache_key})) {
        return    $data;
    }

    # calculate item, store into cache and return it
    return $self->{$cache_key} = $cb->($self);
}

sub payload_spare {
    shift->cached(_payload_spare => sub {
        warn "calculation";
        145
    });
}

package main;

my $item = Item->new();

warn $item->payload_spare;
warn $item->payload_spare;
