
# http://stackoverflow.com/questions/5168104/how-does-listutil-shuffle-actually-work

# Fisher-Yates shuffle
sub shuffle (@) {
    my @a = \(@_);
    my $n;
    my $i = @_;
    map {
        $n = rand($i--);
        (${$a[$n]}, $a[$n] = $a[$i])[0];
    } @_;
}

use Data::Dump;

for(1..10) {
    dd [ shuffle(1..10) ];
}

