
use Test::More;

is scalar %{ +{ a => 'b' } }, '1/8', 'scalar hashref with one key';
is scalar %{ +{} }, 0,               'scalar empty hashref';

done_testing;
