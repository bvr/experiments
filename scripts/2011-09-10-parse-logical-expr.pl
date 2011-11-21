use strict;
use warnings;

use Regexp::Grammars;

my $parser = qr/
<nocontext:>
^<Statement>$

<rule: Statement> <Implication>

<rule: Implication> <L=Disjunction> -> <R=Implication> | <Disjunction>

<rule: Disjunction> <L=Conjunction> \|\| <R=Disjunction> | <Conjunction>

<rule: Conjunction> <L=Term> && <R=Conjunction> | <Term>

<rule: Term> <Variable> | \( <Statement> \)

<token: Variable> \w+
/xms;

my $text = '(P || Q || R) && ((P -> R) -> Q)';
use Data::Dumper;
print Dumper($/{Statement}) if $text =~ $parser;
