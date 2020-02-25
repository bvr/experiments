
use XML::LibXML;
use Text::Trim qw(trim);

my $root = XML::LibXML->load_xml(location => 'files.xml', { no_blanks => 1 })->documentElement;
for my $node ($root->findnodes('//text()')) {
    $node->setData(trim($node->getValue()));
}

open my $out,">:raw","files-formatted.xml" or die;
print {$out} $root->toString(1);
