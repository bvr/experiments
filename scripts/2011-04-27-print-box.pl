use Win32::Unicode::Native;
use ActiveState::Table;

my $t = ActiveState::Table->new;
$t->add_field($_)
    for qw(num twice fourfold);

for (1 .. 5) {
    $t->add_row(
        {   num      => $_,
            twice    => $_ * 2,
            fourfold => $_ * 4,
        }
    );
}

$t->as_box(box_chars=>'unicode');
