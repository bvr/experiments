
use strict;
use Test::More;
use Data::Dump;

# ------------------------------------------------------------------------
package Person;
use Moose;
use overload '""' => sub { shift->as_string };

has [qw(name age)] => (is => 'ro');

sub as_string {
    my $self = shift;
    return $self->name.' ('.$self->age.')';
}


# ------------------------------------------------------------------------
package main;

=head2 build_comparator_on

    my $cmp = build_comparator_on('->name');
    my $cmp = build_comparator_on('->name', desc => 1);    # descending
    my $cmp = build_comparator_on('->age',  numeric => 1); # numeric comparison

Builds a comparator function suitable for use with B<sort> build-in. First
argument is appended to B<$a> and B<$b> variables prior comparison.

=cut
sub build_comparator_on {
    my ($prop, %opts) = @_;

    my ($one, $two) = defined $opts{desc}    ? ('$b', '$a') : ('$a', '$b');
    my $op          = defined $opts{numeric} ? '<=>' : 'cmp';

    return eval "sub { $one$prop $op $two$prop }";
}

# ------------------------------------------------------------------------
# here is actual testing

my @abbr = (
    Person->new(name => 'joe',  age => 15),
    Person->new(name => 'alan', age => 18),
    Person->new(name => 'rick', age => 22),
);

my $by_name = build_comparator_on('->name');
is_deeply
    [ sort $by_name @abbr ],
    ["alan (18)", "joe (15)", "rick (22)"],
    'sort by name';

my $by_age = build_comparator_on('->age', numeric => 1, desc => 1);
is_deeply
    [ sort $by_age @abbr ],
    ["rick (22)", "alan (18)", "joe (15)"],
    'sort by age descending';

done_testing;
