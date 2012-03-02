
use Test::More;
use Test::MockObject;

my $mock = Test::MockObject->new();

my $arg;
$mock->mock(myFunction => sub {
    my $self = shift;
    ($arg) = @_
});

$mock->myFunction("my argument");
is $arg, "my argument", 'correctly passed argument';

done_testing;
