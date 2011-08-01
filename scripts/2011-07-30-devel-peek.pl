use Devel::Peek;

my $test = "value";
Dump($test);
$test = "new value that is much longer";
Dump($test);
