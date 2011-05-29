package CycleSplit;
use Moose;

has 'name'   => (isa => 'Str', is => 'rw');
has 'start'  => (isa => 'Num', is => 'rw');
has 'length' => (isa => 'Num', is => 'rw');

1;

package Cycle;
use Moose;

my @empty = ();

has 'name' => (isa => 'Str', is => 'rw');
has 'splits' => (
    traits  => ['Array'],
    isa     => 'ArrayRef[CycleSplit]',
    is      => 'rw',
    default => sub { [] },
    handles => {add_item => 'push',},
);

no Moose;
1;

package Main;

sub Main {
    my $cyc = Cycle->new();
    $cyc->name("Days of week");

    for my $i (1 .. 7) {
        my $spl = CycleSplit->new();
        $spl->name("Day $i");
        $spl->start($i / 7 - (1 / 7));
        $spl->length(1 / 7);
        $cyc->add_item($spl);
    }

    my $text = '';
    foreach my $spl (@{$cyc->splits}) {
        $text .= $spl->name . " ";
    }

    print $text;
}

Main;
