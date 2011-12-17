
use ActiveState::Table;

my $t = ActiveState::Table->new;
$t->add_field($_) for qw(Breakpoint Value);

$t->add_row({Breakpoint => $_, Value => 2*$_ }) for 1..4;

binmode STDOUT => ':utf8';
$t->as_box(box_chars => 'unicode');


