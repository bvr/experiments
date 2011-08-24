
use strict; use warnings;

package Father;
use constant CONST => 1;

package Child;
use base 'Father';
sub new { bless {}, shift }

package main;
my $c = Child->new;
print $c->CONST;        # 1
print CONST();          # undefined subroutine
