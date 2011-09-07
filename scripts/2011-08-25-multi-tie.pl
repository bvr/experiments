
package ClassA;
require Tie::Scalar;
our @ISA = qw(Tie::StdScalar);

package ClassB;
require Tie::Scalar;
our @ISA = qw(Tie::StdScalar);

package main;
use Devel::Peek;

my $x;

tie $x, 'ClassA';
tie $x, 'ClassB';

Dump($x);

