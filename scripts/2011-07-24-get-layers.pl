
use open qw(:std :utf8);

open $in, '<', $0 or die;

my @layers = PerlIO::get_layers($in);
use Data::Dump;
dd @layers;
