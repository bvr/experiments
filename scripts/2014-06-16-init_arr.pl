
use Data::Dump;
use Getopt::Long qw(GetOptionsFromArray);

my @empty = ();
GetOptionsFromArray([qw(--xyz=aa --xyz=bb --verbose)],
    'xyz=s@'  => \(my $files   = []),
    'verbose' => \(my $verbose = 0),
);

dd $files, $verbose;
