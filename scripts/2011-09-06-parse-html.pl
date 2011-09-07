
use HTML::TreeBuilder;

my $html = HTML::TreeBuilder->new_from_content(<<END_HTML);
<a href="http://address.com">John</a>: I really <b>love</b> <b>soccer</b>;
END_HTML

my $name     = $html->find('a')->as_text;               # "John"
my @keywords = map { $_->as_text } $html->find('b');    # "love", "soccer"
my $comment  = $html->as_text;                          # "John: I really love soccer; "
