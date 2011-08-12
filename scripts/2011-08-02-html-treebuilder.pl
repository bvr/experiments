
use HTML::TreeBuilder;
use Data::Dump qw(dd);

my $html = 'aaa<table>test</table>bbb<table>test2</table>ccc';
my $tree = HTML::TreeBuilder->new_from_content($html);

# remove all <table>....</table>
$_->delete for $tree->find('table');

dd($tree->guts);        # ("aaa", "bbb", "ccc")
