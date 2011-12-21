use Win32::Unicode::Native;
use LWP::Simple qw(get);
use HTML::TreeBuilder;
use HTML::FormatText;

my $url  = 'http://www.abclinuxu.cz/poradna/programovani/show/304922';
my $tree = HTML::TreeBuilder->new_from_content(get($url));

$formatter = HTML::FormatText->new(leftmargin => 0, rightmargin => 80);
print $formatter->format($tree);

