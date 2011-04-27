

use MooseX::Declare;
class Person {

    use Moose::Util::TypeConstraints;

    subtype 'Email'
        => as 'Str'
        => where {/^(.+)\@(.+)$/};

    has id    => (is => 'ro', isa => 'Int');
    has name  => (is => 'ro', isa => 'Str');
    has email => (is => 'ro', isa => 'Email');
}

package main;

use Try::Tiny;
use Data::Dump qw(pp dd);

my @tests = (
    { id => 1,          name => 'John Doe', email => 'john@doe.net'},
    { id => 'John Doe', name => 1,          email => 'john.at.doe.net'},
);

for my $query (@tests) {
    try {
        my $person = Person->new(%$query);
        warn pp($query) . " - OK\n";
    }
    catch {
        dd $_;
        warn pp($query) . " - Failed\n";
    };
}
