
# from http://stackoverflow.com/questions/5387116/parsing-element-includng-attribute-and-text-nodes-of-xml-document-using-perl

use strict;
use warnings;

use XML::LibXML qw( );

my $parser = XML::LibXML->new();
my $doc    = $parser->parse_file("test.xml");
my $root   = $doc->documentElement();

for my $node ($root->findnodes('//*[@title]')) {
    my $name   = $node->nodeName();
    my $title  = $node->getAttribute('title');
    my @params = map $_->textContent, $node->findnodes('params');
    printf("%-10s %-11s %s\n", $name, $title, join(' ', @params));
}
