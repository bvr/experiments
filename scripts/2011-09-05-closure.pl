

sub make_add_func {
    my $amount = shift;
    return sub {
        my $number = shift;
        return $number + $amount;
    }
}

my $add_two  = make_add_func(2);
my $add_five = make_add_func(5);
print($add_two->(1) + $add_five->(1));      # prints 9
