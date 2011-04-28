
use strict; use warnings;
use XML::Twig;

my $twig = XML::Twig->new( twig_handlers => {
    '//*[@title]' => sub {
        print join("\t",
            $_->gi,
            $_->att('title'),
            map { $_->trimmed_text } $_->findnodes('params')
        ), "\n";
    }
} );
$twig->parsefile('test.xml');
