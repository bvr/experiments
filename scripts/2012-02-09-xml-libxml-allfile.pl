
use XML::LibXML;

my $parser = XML::LibXML->new();
my $tree = $parser->parse_string(<<END) or die $!;
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
 <property>
   <name>test.name</name>
   <value>help</value>
   <description>xml issue</description>
 </property>
</configuration>
END

my $root   = $tree->getDocumentElement;

my $name = "test.name";
my $searchPath = "/configuration/property[name=\"$name\"]/value/text()";
my ($val) = $root->findnodes($searchPath);

$val->setData($new_val);
print $tree->toString(1);

