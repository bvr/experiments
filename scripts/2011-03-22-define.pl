
use strict; use warnings;

BEGIN {
    if ($] < 5.012) {
        *say = sub { print @_, "\n" }
    }
}

