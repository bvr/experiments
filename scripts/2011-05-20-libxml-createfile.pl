use XML::LibXML;
use List::MoreUtils qw(natatime);

my $doc  = XML::LibXML->createDocument;
my $root = $doc->createElement("foo");
$doc->setDocumentElement($root);

my $attr = $doc->createAttribute("bar" => "test");
$root->setAttributeNodeNS($attr);

my @tags = (
    version => '1.0.0',
    app     => 'ConstDict',
    eid     => 'E374642',
    model   => 'PF_RY_WHATEVER',
);

my $it = natatime 2, @tags;
while(my ($key,$value) = $it->()) {
    my $node = $doc->createElement($key);
    $node->appendText($value);
    $root->appendChild($node);
}

warn $doc->toString(1);
