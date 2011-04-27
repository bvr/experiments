
my @files = (<*.pl>)[0..9];

my %file_handles = ();
for (@files) {
    open $file_handles{$_}, "<", $_
        or die "Could not open $_: $!";
}

for my $i (1..5) {
    print "$i\n";
    for my $filename (sort keys %file_handles) {
        print scalar readline $file_handles{$filename};
    }
}

close $_ for values %file_handles;
