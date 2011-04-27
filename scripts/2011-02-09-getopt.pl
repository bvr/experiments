
use Getopt::Long;

my %h = ();
GetOptions(\%h,
    'ip:s',
    'id:s',
    'class:s',
) or die "Could not parse";
warn map { "$_=>$h{$_} " } keys %h;
