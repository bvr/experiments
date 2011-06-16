
# also look into Bread::Board's t/051_more_parameterized_containers.t

package Wheel;
use Moose;

has ['size', 'maker'] => (isa => 'Str', is => 'rw');


package Vehicle;
use Moose;

has 'wheels' => (
    is => 'rw',
    isa => 'ArrayRef[Wheel]',
    required => 1,
);


package main;
use Bread::Board;

my $c = container 'app' => as {
    container 'wheels' => as {
        service 'carTires' => (
            block => sub { return [ map { Wheel->new } 1..4 ] },
        )
    };

    container 'vehicles' => as {
        service 'sedan' => (
            class   => 'Vehicle',
            dependencies => {
                wheels => depends_on('/wheels/carTires'),
            }
        )
    };
};
my $v = $c->resolve(service => 'vehicles/sedan');

