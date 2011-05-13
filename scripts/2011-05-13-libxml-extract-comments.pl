use 5.010; use strict; use warnings;
use XML::LibXML;

my $srcfile = shift;

my $root = XML::LibXML->new->parse_file( $srcfile )->documentElement;
say join("\n",map { $_->textContent } $root->findnodes('//comment()'));
