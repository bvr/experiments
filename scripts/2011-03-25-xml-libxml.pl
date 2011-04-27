
# XML::LibXML example and nice XPath expression
# http://stackoverflow.com/questions/5433755/single-line-regular-expression-needed-for-a-pattern-in-perl

use XML::LibXML
my $parser = XML::LibXML->new();
$parser->recover(1);                 # don't fail on parsing errors
my $doc = do {
    local $SIG{__WARN__} = sub {};   # silence warning about parsing errors
    $parser->parse_html_file('http://www.trainenquiry.com/StaticContent/Railway_Amnities/Enquiry%20-%20North/STATIONS.aspx');
};

print $_->toString() for $doc->findnodes('//tr[td[1][@class="td_background"]]');
