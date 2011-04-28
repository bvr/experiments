use strict;
use warnings;

sub qsort (\@) {_qsort($_[0], 0, $#{$_[0]})}

sub _qsort {
    my ($array, $low, $high) = @_;
    if ($low < $high) {
        my $mid = partition($array, $low, $high);
        _qsort($array, $low,     $mid - 1);
        _qsort($array, $mid + 1, $high   );
    }
}

sub partition {
    my ($array, $low, $high) = @_;
    my $x = $$array[$high];
    my $i = $low - 1;
    for my $j ($low .. $high - 1) {
        if ($$array[$j] <= $x) {
            $i++;
            @$array[$i, $j] = @$array[$j, $i];
        }
    }
    $i++;
    @$array[$i, $high] = @$array[$high, $i];
    return $i;
}

my @array = (4, 3, 9, 2, 1, 7, 5, 8);
qsort @array;
print "@array\n"; # 1 2 3 4 5 7 8 9

