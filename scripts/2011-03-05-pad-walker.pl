use PadWalker qw/peek_my peek_our/;

sub get_name_my {
    my $pad = peek_my($_[0] + 1);
    for (keys %$pad) {
        return $_ if $$pad{$_} == \$_[1]
    }
}
sub get_name_our {
    my $pad = peek_our($_[0] + 1);
    for (keys %$pad) {
        return $_ if $$pad{$_} == \$_[1]
    }
}
sub get_name_stash {
    my $caller = caller($_[0]) . '::';
    my $stash = do {
        no strict 'refs';
        \%$caller
    };
    my %lookup;
    for my $name (keys %$stash) {
        if (ref \$$stash{$name} eq 'GLOB') {
            for (['$' => 'SCALAR'],
                 ['@' => 'ARRAY'],
                 ['%' => 'HASH'],
                 ['&' => 'CODE']) {
                if (my $ref = *{$$stash{$name}}{$$_[1]}) {
                    $lookup{$ref} ||= $$_[0] . $caller . $name
                }
            }
        }
    }
    $lookup{\$_[1]}
}
sub get_name {
    unshift @_, @_ == 2 ? 1 + shift : 1;
    &get_name_my  or
    &get_name_our or
    &get_name_stash
}

sub debug {
    for (@_) {
       my $name = get_name(1, $_) || 'name not found';
       print "$name: $_\n";
    }
}


my $x = 5;
our $y = 10;
$main::z = 15;

debug $x, $y, $main::z;
