
use 5.016; use strict; use warnings;
use XML::LibXML;

my $xml = XML::LibXML->new->load_xml(IO => \*DATA);
say $xml->toString(1);

__DATA__
<?xml version="1.0"?>
<tool><name>TPP1</name><major>1</major><minor>0</minor><revision>0</revision><installer></installer><min_version>0.0.0</min_version><support_files/></tool>
