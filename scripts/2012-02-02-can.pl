

package One;

sub thing { warn 1 }

package Two;
our @ISA = 'One';
use Data::Dump;

sub thing { dd(2, @_) }

package Three;
our @ISA = 'Two';

sub thing { p(3, @_) }

package main;
use Data::Printer deparse => 1;

my $call = Two->can('thing');
my $obj = bless {}, 'Three';

$obj->$call();


p $call;

