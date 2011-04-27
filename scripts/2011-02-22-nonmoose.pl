
package SomeClass;

sub new {
    my $class = shift;
    warn "options = ", @_, "\n";
    bless { @_ }, $class;
}


package SubClass;
use Moose;
use MooseX::NonMoose;
extends 'SomeClass';

has attr => (is => 'ro');

__PACKAGE__->meta->make_immutable();


package main;

my $sc = SubClass->new(attr => 'Joe', other => 'Thing');

dump $sc;
