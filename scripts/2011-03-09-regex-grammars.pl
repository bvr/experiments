use 5.010;
use warnings;
use Regexp::Grammars;

my $parser = qr{
    <Sentence>

    <rule: Sentence>        <subject> <verb> <object>
    <rule: subject>         <noun_phrase>
    <rule: object>          <noun_phrase>
    <rule: noun_phrase>     <pronoun> | <proper_noun> | <article> <noun>

    <token: verb>           wrote | likes | ate
    <token: article>        a | the | this
    <token: pronoun>        it | he
    <token: proper_noun>    Perl | Dave | Larry
    <token: noun>           book | cat
}xms;

use Data::Dump;

while (<DATA>) {
    chomp;
    print "'$_' is ";
    print 'NOT ' unless $_ =~ $parser;
    say 'a valid sentence';
    dd \%/, \@!;  # /

}

__DATA__
Larry wrote Perl
Larry wrote a book
Dave likes Perl
Dave likes the book
Dave wrote this book
the cat ate the book
Dave got very angry
