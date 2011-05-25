use XML::LibXML;

my $doc = XML::LibXML->load_xml(string => <<ENDXML);
<platforms>
  <asianux-64>
    <name>Asianux 3</name>
    <type>64-bit</type>
  </asianux-64>
  <asianux3>
    <name>Asianux 3</name>
    <type>32-bit</type>
  </asianux3>
  <debian3>
    <name>Debian GNU/Linux 3</name>
    <type>32-bit</type>
  </debian3>
  <debian3-64>
    <name>Debian GNU/Linux 3</name>
    <type>32-bit</type>
  </debian3-64>
  <debian4>
    <name>Debian GNU/Linux 4</name>
    <type>32-bit</type>
  </debian4>
  <debian4-64>
    <name>Debian GNU/Linux 4</name>
    <type>64-bit</type>
  </debian4-64>
  <debian5>
    <name>Debian GNU/Linux 5</name>
    <type>32-bit</type>
  </debian5>
  <debian5-64>
    <name>Debian GNU/Linux 5</name>
    <type>64-bit</type>
  </debian5-64>
</platforms>
ENDXML

my $rng = XML::LibXML::RelaxNG->new(string => <<ENDSCHEMA);
<?xml version="1.0"?>
<element name="platforms" xmlns="http://relaxng.org/ns/structure/1.0">
  <zeroOrMore>
    <element>
      <anyName/>
      <element name="name"> <text/> </element>
      <element name="type"> <text/> </element>
    </element>
  </zeroOrMore>
</element>
ENDSCHEMA

$rng->validate($doc);

