
use XML::Parser;
use utf8;
use Win32::Unicode::Native;

my $parser = XML::Parser->new( Handlers => {
    Char => sub {
        my ( $expat, $string ) = @_;
        warn "is_utf8 = ",utf8::is_utf8($string),"\n";
        print $string,"\n";
    } ,
} );

$parser->parsefile('xml.xml')
