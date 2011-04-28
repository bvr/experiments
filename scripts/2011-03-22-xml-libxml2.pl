
# from http://stackoverflow.com/questions/5387116/parsing-element-includng-attribute-and-text-nodes-of-xml-document-using-perl

use strict;
use warnings;

use XML::LibXML qw( XML_ELEMENT_NODE );

sub find_params {
    my ($node) = @_;

    my @params;
    for my $child ($node->childNodes()) {
        next if $child->nodeType != XML_ELEMENT_NODE;
        next if $child->nodeName ne 'params';
        push @params, $child->textContent();
    }

    return @params;
}

sub visit {
    my ($node) = @_;
    return if $node->nodeType != XML_ELEMENT_NODE;

    if (my $title_node = $node->getAttributeNode('title')) {
        printf("%-10s %-11s %s\n",
            $node->nodeName(),
            $title_node->getValue(),
            join(' ', find_params($node)),
        );
    }

    visit($_) for $node->childNodes();
}

my $parser = XML::LibXML->new();
my $doc    = $parser->parse_file("test.xml");
my $root   = $doc->documentElement();

visit($root);

