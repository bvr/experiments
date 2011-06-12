use XML::LibXML;

my $parser = XML::LibXML->new;
my $doc = $parser->parse_file("mytest.xml");
my $root = $doc->getDocumentElement();

my $new_element= $doc->createElement("element4");
$new_element->appendText('testing');

$root->appendChild($new_element);

print $root->toString(1);
