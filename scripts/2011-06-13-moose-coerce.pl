
package CoerceTest;
use Moose;
use Scalar::Util qw(looks_like_number);

use Moose::Util::TypeConstraints;

subtype  'PlainNum',
    as   'Maybe[Str]',
    where { ! defined $_ || (looks_like_number($_) && $_ !~ /\s/) };

coerce   'PlainNum',
    from 'Str',
    via  { $_ =~ /^\s*$/s ? undef : 0+$_ };

no Moose::Util::TypeConstraints;

has item => (is => 'rw', isa => 'PlainNum', coerce => 1, writer => 'set_item');

package main;
use Test::More;

is(CoerceTest->new(item => '     ')->item,     undef, 'spaces to undef');
is(CoerceTest->new(item => 12)->item,          12,    'simple number');
is(CoerceTest->new(item => '   12   ')->item,  12,    'simple number in string w/whitespace');
is(CoerceTest->new(item => '   12.5e2')->item, 1250,  'float number in string w/whitespace');

done_testing;
