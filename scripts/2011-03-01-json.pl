
package Node;

sub new {
    my $class = shift;
    bless { @_ }, $class;
}

sub TO_JSON {
    my $self = shift;

    my %data;
    @data{keys %$self} = values %$self;
    return \%data;
}

package main;

use JSON;

my $node_hash = {
    a => [ 'text1', 'text2' ],
    b => [ 'what',  'is', 'this' ],
    c => [ Node->new(some => 'data') ],
};

print to_json($node_hash, { convert_blessed => 1 });

