
use XML::LibXML;

my $doc = XML::LibXML->load_xml(string => <<END_XML, { no_blanks => 1 });
                                    <nested_nodes>
                                        <nested_node>
                                        <configuration>A</configuration>
                                        <model>45</model>
                                        <added_node>
        <ID>
            <type>D</type>
            <serial>3</serial>
            <kVal>3</kVal>
        </ID>
    </added_node>
</nested_node>
                                    </nested_nodes>
END_XML

print $doc->toString(1);
