
package Foo::Bar;
use Moose::Role;


package WithFooBar;
use Moose;
with 'Foo::Bar';


package Thing;
use Moose;

has foo => (is => 'ro', isa => 'Maybe[Foo::Bar]');

package main;
use Test::More;

ok(Thing->new(foo => undef));               # pass
ok(Thing->new(foo => WithFooBar->new));     # pass
ok(Thing->new(foo => Thing->new));          # fails

done_testing;
