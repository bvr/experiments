
use Data::Dump;

my $want_bigint = 1;

# use bigint;
eval 'use bigint; dd 9**9' if $want_bigint;

dd 16;
dd 15;

