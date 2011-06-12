
# from http://stackoverflow.com/questions/6240246/how-do-i-process-this-file-using-awk-or-perl

use Statistics::Lite qw(statsinfo);

while (<DATA>) {
    my ($a, $b) = split;
    push @{$items{$a}}, $b;
}

foreach my $key (keys %items) {
    print "$key\n";
    print statsinfo(@{$items{$key}});
}

__DATA__
<itemA>    1
<itemA>    2
<itemA>    3
<itemA>    4
<itemB>    5
<itemB>    7
<itemC>    10
<itemC>    12
