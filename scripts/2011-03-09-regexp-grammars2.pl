#! /usr/bin/env perl
use strict; use warnings;
use 5.010;
use JSON;
use Regexp::Grammars;


my $str = '[[,action1,,],[action2],[],[,],[,[],]]';

my $parser = qr{
  <match=Array>

  <token: Text>
    [^,\[\]]*

  <token: Element>
  (?:
    <.Text>
  |
    <MATCH=Array>
  )

  <token: Array>
  \[
     (?:
       (?{ $MATCH = [qw'']; })
     |
       <[MATCH=Element]>   ** (,)
     )
  \]
}x;


if( $str =~ $parser ){
  say to_json $/{match};
}else{
  die $@ if $@;
}

