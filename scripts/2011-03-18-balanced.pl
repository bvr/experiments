
use Regexp::Grammars;
use Data::Dump;

my $input
    = q{abc[1,2,3].something.here,foo[10,6,34].somethingelse.here,def[1,2].another};

my $re = qr{
    <[tokens]> ** (,)       # comma separated tokens

    <rule: tokens>     <.token>*
    <rule: token>      \w+ | [.] | <bracketed>
    <rule: bracketed>  \[ <.token> ** (,) \]
}x;

dd $/{tokens}
    if $input =~ $re;

# prints
# [
#   "abc[1,2,3].something.here",
#   "foo[10,6,34].somethingelse.here",
#   "def[1,2].another",
# ]
