
use Test::More;
use List::Util 'reduce';

sub name_prefix {
    my @items = @_;
    return reduce {
        my $i = 0;
        for(;substr($a, $i, 1) eq substr($b, $i, 1); $i++){}
        substr $a, 0, $i;
    } @items;
}

is  name_prefix(qw(
        Bread::Board::Dependency
        Bread::Board::ConstructorInjection
        Bread::Board::Container
    )),
    'Bread::Board::',
    'found the prefix';

done_testing;
