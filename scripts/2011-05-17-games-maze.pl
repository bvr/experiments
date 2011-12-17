
use strict;
use Games::Maze;
use Data::Dump;

my $maze = Games::Maze->new(
    form       => 'Rectangle',
    cell       => 'Quad',
    dimensions => [15, 15, 1]
);

$maze->make();
print "\n\nThe Maze...\n", scalar($maze->to_ascii());
$maze->solve();
print "\n\nThe Solution...\n", scalar($maze->to_ascii()), "\n";

# maze properties.
dd { $maze->describe() };
