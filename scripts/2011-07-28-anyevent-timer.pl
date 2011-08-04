
use 5.010; use strict; use warnings;
use AnyEvent;

my $c = 0;
my $cv = AnyEvent->condvar;
my $once_per_second = AnyEvent->timer(after => 0, interval => 1, cb => sub { $c++ });
my $five_seconds    = AnyEvent->timer(after => 5, cb => sub { $cv->send });
$cv->recv;
say $c;

