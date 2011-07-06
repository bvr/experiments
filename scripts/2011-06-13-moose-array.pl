package Objekt;
use Moose;
use List::Util qw(sum);

has pole => (
    is      => 'rw',
    traits  => ['Array'],
    default => sub { [] },
    handles => {
        add_prvek  => 'push',
        list_pole  => 'elements',
        count_pole => 'count',
    },
);

sub prumer {
    my $self = shift;
    return sum($self->list_pole) / $self->count_pole;
}

# pouziti
package main;

my $obj = Objekt->new(pole => [1..10]);
print $obj->prumer;

