
use Test::More;
use Test::Exception;

lives_and { is not_throwing(), "42" } 'passing test';
lives_and { is     throwing(), "42" } 'failing test';

done_testing;

sub not_throwing { 42 }
sub throwing     { die "failed" }
