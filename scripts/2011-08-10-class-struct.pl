
package Account;
use Class::Struct
    map { $_ => '$' } qw(
        first_name
        last_name
        age_in_years
        activated
        items
    );

my $old_new = \&new;
*new = sub {
    my $class = shift;
    $old_new->($class,
        activated => 1,
        @_
    );
};

package main;

my $acc = Account->new(
    first_name => 'John',
    last_name  => 'Doe',
    items      => ['a' .. 'z']
);

use Data::Dump;
dd $acc;
