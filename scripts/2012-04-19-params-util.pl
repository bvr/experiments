
use Test::More;
use Params::Util qw(_HASHLIKE);

diag ref({});
diag ref(Thing->new);

ok _HASHLIKE({}), 'empty hashref';
ok _HASHLIKE(Thing->new(name => 'Roman')), 'Moose object';
ok !_HASHLIKE('Roman'), 'String';
ok !_HASHLIKE(10), 'Number';

done_testing;

BEGIN
{
package Thing;
use Moose;
has name => (is => 'ro');
}
