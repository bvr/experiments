
package Foo;
use Moose;
use MooseX::Params::Validate;

sub foo {
    my ($self, %params) = validated_hash( \@_,
        bar => {isa => 'Str', default => 'Moose'},
    );
    return "Hooray for $params{bar}!";
}

sub bar {
    my $self = shift;
    my ($foo, $baz, $gorch) = validated_list( \@_,
        foo   => {isa => 'Foo'},
        baz   => {isa => 'ArrayRef | HashRef', optional => 1},
        gorch => {isa => 'ArrayRef[Int]',      optional => 1}
    );
    return [$foo, $baz, $gorch];
}

sub baz {
    my $self = shift;
    my ($foo, $bar) = pos_validated_list( \@_,
        {isa => 'Foo'},
        {isa => 'ArrayRef[Str]'},
    );
    return [$foo, $bar];
}

package main;

use Data::Dump;


my $f = Foo->new;

dd $f->foo(bar => 'Roman');
dd $f->bar(foo => $f, baz => [ 1..4 ], gorch => [ 1..4 ]);
dd $f->baz($f, [ 'a' .. 'c' ]);
