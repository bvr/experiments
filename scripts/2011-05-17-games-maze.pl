use Games::Maze;

#
# Create and print the maze and the solution to the maze.
#
my $minos = Games::Maze->new(dimensions => [15, 15, 3]);
$minos->make();
print "\n\nThe Maze...\n", scalar($minos->to_ascii());
$minos->solve();
print "\n\nThe Solution...\n", scalar($minos->to_ascii()), "\n";

#
# We're curious about the maze properties.
#
my %p = $minos->describe();

foreach (sort keys %p) {
    if (ref $p{$_} eq "ARRAY") {
        print "$_ => [", join(", ", @{$p{$_}}), "]\n";
    }
    else {
        print "$_ => ", $p{$_}, "\n";
    }
}
