
# from Eric Strom on http://stackoverflow.com/questions/5662716/how-can-i-join-two-lists-using-map/5668077#5668077

use B ();
use List::Util 'min';

sub pairwise (&\@\@) {
    my ($code, $xs, $ys) = @_;
    my ($a, $b) = do {
        my $caller = B::svref_2object($code)->STASH->NAME;
        no strict 'refs';
        map \*{$caller.'::'.$_} => qw(a b);
    };

    map {
        local *$a = \$$xs[$_];
        local *$b = \$$ys[$_];
        $code->()
    } 0 .. min $#$xs, $#$ys
}

