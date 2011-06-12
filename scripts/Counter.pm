package Counter;
use Sub::Exporter -setup => {
    groups => [counter => \'_gen_counter'],
};

sub _gen_counter {
    my ($class, $name, $arg) = @_;

    my $cb = $arg->{callback};
    my @log;

    # build three exported routines
    return {
        record => sub {
            my ($value) = @_;
            $cb->($value) if $cb and @_;
            push @log, $value;
        },

        list => sub {
            return @log;
        },

        count => sub {
            return scalar @log;
        }
    };
}

1;
