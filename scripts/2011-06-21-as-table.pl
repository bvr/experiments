
use ActiveState::Table;
use utf8::all;

my $t = ActiveState::Table->new;
$t->add_field($_) for qw(Element Count);
my $total = 0;
while(<DATA>) {
    chomp;
    my ($elem,$num) = split /\t/;
    $t->add_row({ Element => $elem, Count => $num });
    $total += $num;
}
$t->add_sep;

$t->add_row({ Element => 'Total', Count => $total });
$t->add_row({ Element => 'Links', Count => 224196 });
$t->as_box(show_trailer => 0, align => { Count => 'right' }, box_chars=>'unicode');

__DATA__
Documents 	7737
HRD anchors 	7428
SCD anchors 	4504
SRC anchors 	2986
SRDD anchors 	36285
SRS anchors 	1810
TPP anchors 	10528
TST anchors 	1314
TVO anchors 	4203
