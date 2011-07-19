
use TAP::Harness;
use TAP::Formatter::HTML;

my $fmt = TAP::Formatter::HTML->new({ force_inline_css => 0 });
my $harness = TAP::Harness->new( { formatter => $fmt, merge => 1 } );
$fmt->output_file('output.html');

$harness->runtests('1.t');

