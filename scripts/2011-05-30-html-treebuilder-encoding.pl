
use HTML::TreeBuilder;
use LWP::Simple qw(get);

my $data = get('http://www.linuxsoft.cz/article.php?id_article=1474');
my $tree = HTML::TreeBuilder->new_from_content($data);

binmode(STDOUT,':utf8');
for my $art ($tree->look_down(_tag => 'td', class => 'articles')) {
    print $art->as_text();
}

# print $tree->as_HTML('<>&',"\t");
