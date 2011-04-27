use 5.10.1; use strict; use warnings;

use Regexp::Grammars;

my $grammar = qr{
  <line>

  <token: line>
    (?: <[pair]> \s* )+

    (?{
      my $arr = $MATCH{pair};
      local $MATCH = {};

      for my $pair( @$arr ){
        my($key)   = keys   %$pair;
        my($value) = values %$pair;
        $MATCH->{$key} = $value;
      }
    })

  <token: pair>
    <attrib> \s* \( \s* <value> \s* \)
    (?{
      $MATCH = {
        $MATCH{attrib} => $MATCH{value}
      };
    })

  <token: attrib>
    [^()]*?

  <token: value>
    (?:
      <MATCH=pair> |
      [^()]*?
    )
}x;

use warnings;

my %attr;
while( my $line = <DATA> ){
  $line =~ /$grammar/;
  for my $key ( keys %{ $/{line} } ){
    $attr{$key} = $/{line}{$key};
  }
}

use YAML;

say Dump \%attr;

__DATA__
CHANNEL(TO.IPTWX01)                     CHLTYPE(CLUSRCVR)
DISCINT(6000)                           SHORTRTY(10)
TRPTYPE(TCP)                            DESCR( )
LONGTMR(1200)                           SCYEXIT( )
CONNAME(NODE(1414))                     MREXIT( )
MREXIT( )                               CONNAME2(SOME(1416))
TPNAME( )                               BATCHSZ(50)
MCANAME( )                              MODENAME( )
ALTTIME(00.41.56)                       SSLPEER()
CONTRIVED()                             ATTR (00-41-56)
CONTRIVED()                             DOCTORED()
MSGEXIT( )
