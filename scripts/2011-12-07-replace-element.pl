
use XML::LibXML;

my $parser =XML::LibXML->new();
$tree   =$parser->load_xml(string => <<DATA);
   <testing>
<application_name>TEST</application_name>
<application_id>VAL1</application_id>
<application_password>1234</application_password>
   </testing>
DATA

$root   =$tree->getDocumentElement;
my ($elem)=$root->findnodes('/testing/application_id');

$elem->removeChildNodes();
$elem->appendText('VAL2');

print $tree->toString();
# $elem->setValue('VAL2');
