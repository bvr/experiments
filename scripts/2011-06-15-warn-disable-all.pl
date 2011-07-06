#!perl -X

# the way how to disable warnings in whole application

package Thing;
use Moose;

my $a;
print $a;

package main;

my $x = Thing->new;
