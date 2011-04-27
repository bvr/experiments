use Regexp::Grammars;
use Data::Dumper;
use strict;
use warnings;

my $parser = qr{
    <[pair]>+
    <rule: pair>     <key>=(?:"<list>"|<value=literal>)
    <token: key>     var\d+
    <rule: list>     <[MATCH=literal]> ** (,)
    <token: literal> \S+

}xms;

q[var1=100 var2=90 var5=hello var3="a, b, c" var7=test var3=hello] =~ $parser;
die Dumper {%/};  # /

