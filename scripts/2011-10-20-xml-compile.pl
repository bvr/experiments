#!/usr/local/bin/perl

use warnings;
use strict;

use Data::Dumper;
use XML::Compile::Schema;
use XML::LibXML::Reader;

my $xsd = 'cdd.xsd';

my $schema = XML::Compile::Schema->new($xsd);

# This will print a very basic description of what the schema describes
# $schema->printIndex();

# this will print a hash template that will show you how to construct a
# hash that will be used to construct a valid XML file.
#
# Note: the second argument must match the root-level element of the XML
# document.  I'm not quite sure why it's required here.
# warn $schema->template('PERL', 'Constants');


my $data = {

    Relatedto   => "MODEL_NAME",
    Description => "",
    SourceTrace => "SRDD_something",
    Anchor      => "MODEL_NAME_CDD",

    cho_Constant => [
        {   Constant => {
                Name        => "const1",
                Description => "Description of constant",
                Dimension   => "0",
                Type        => "double",
                Units       => "anything",
                Min         => "",
                Max         => "",

                Value => [
                    {   Setup => "1",
                        _     => do {
                            my $e = XML::LibXML::Element->new('Value');
                            $e->appendText('0 1 2 3');
                            $e;
                        },
                    },
                    {   Setup => "2",
                        _     => do {
                            my $e = XML::LibXML::Element->new('Value');
                            $e->appendText('3 4 5 6');
                            $e;
                        },
                    },
                ],
            },
        },
    ],
};

my $doc    = XML::LibXML::Document->new('1.0', 'UTF-8');
my $write  = $schema->compile(WRITER => 'Constants');
my $xml    = $write->($doc, $data);

$doc->setDocumentElement($xml);

print $doc->toString(1); # 1 indicates "pretty print"
