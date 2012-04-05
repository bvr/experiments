
use Data::Dump;

sub build_comparator_on {
    my ($prop, %opts) = @_;

    my ($one, $two) = defined $opts{desc}    ? ('$b', '$a') : ('$a', '$b');
    my $op          = defined $opts{numeric} ? '<=>' : 'cmp';

    return eval "sub { $one->$prop $op $two->$prop }";
}

my $by_heading = build_comparator_on('{heading}');

my @abbr = (
    { heading => 'joe' },
    { heading => 'alan' },
    { heading => 'rick' },
);

dd [ sort $by_heading @abbr ];
