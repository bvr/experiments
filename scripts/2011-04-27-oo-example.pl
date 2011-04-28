
use 5.010;          # i want say

package Otec;

sub say_hello {
    say "Hello man!";
}


package Trida;

our @ISA = qw(Otec Matka);

sub new {
    my $class = shift;
    return bless { @_ }, $class;
}

sub name { shift->{name} }

sub say_name {
    my $self = shift;
    say $self->name;
}

sub say_hi {
    my $self = shift;
    say "This is override";
    $self->SUPER::say_hello;
}


package main;

my $object = Trida->new(name => 'Franta');

$object->say_name;      # directly from Trida
$object->say_hello;     # inherited from Otec
$object->say_hi;        # pass to parent class

$object->undefined;     # failure

