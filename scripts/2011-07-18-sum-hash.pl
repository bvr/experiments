
use List::Util qw(sum);

my %hash = qw(
    000 23
    012 42
    222 34
);

# [(0+0+0)*23]+[(0+1+2)*42]+[(2+2+2)*34]=0+126+204=330
print sum(map { sum(split //) * $hash{$_} } keys %hash);    # 330


