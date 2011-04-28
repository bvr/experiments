
use 5.010;
# or ...
#
# use 5.10.0
# use feature ':5.10';
# use feature qw(say);

# say

say "Hello";


# defined or

$c = $a // $b;   # /

# switch

$a = 5;
given($a) {
    when(5) { say "5" }
}
