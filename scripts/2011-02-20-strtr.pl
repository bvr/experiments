
my %h = (
    'ahoj' => 1,
    'ah'   => 2,
    'oj'   => 3,
);
$a = 'ahoj';

my $keys = join '|', sort { length($b) <=> length($a) } keys %h;
$a =~ s/($keys)/$h{$1}/g;

warn $a;
