
    # skip header
    my $header = <DATA>;

    # read data into a hash
    my %summary =();
    while(<DATA>) {
        chomp;
        my ($timestamp, @amounts) = split;
        for my $i (0..$#amounts) {
            $summary{$timestamp} ||= [];
            $summary{$timestamp}[$i] += $amounts[$i];
        }
    }

    # print out the summary
    for my $timestamp (sort { $a <=> $b } keys %summary) {
        print $timestamp,"  ",join("  ",@{ $summary{$timestamp} }),"\n";
    }



    __DATA__
    timestamp, amount1, amount2, amount3
    12334        20         0       0
    12335        0         20       0
    12335        0         20       20
    12336        0         20       0
    12336        0         20       20
