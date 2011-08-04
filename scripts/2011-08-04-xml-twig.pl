
use XML::Twig;

my $xml = <<END_XML;
<Open>
    <ID>7175</ID>
    <Name>GEENU</Name>
    <Description>CHUMMA</Description>
    <Active>1</Active>
    <Users>1</Users>
</Open>
END_XML

my $twig = XML::Twig->new(
    twig_handlers => {
        Description => sub {
            my $text = $_->trimmed_text();
            if($text eq 'CHUMMA') {
                $_->set_text($text . ',GEENU');
            }
        },
    },
    pretty_print => 'indented',
);
$twig->parse($xml);
$twig->print;

__END__
<Open>
  <ID>7175</ID>
  <Name>GEENU</Name>
  <Description>CHUMMA,GEENU</Description>
  <Active>1</Active>
  <Users>1</Users>
</Open>
