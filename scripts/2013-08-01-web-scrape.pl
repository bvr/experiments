
use LWP::Simple qw(get);
use HTML::TreeBuilder;
use Path::Class;
use Try::Tiny;

my $page
  = q{http://www.piskari.cz/cesta.php?cid=419};

my $cache = file('cache');
my $page_content = try { $cache->slurp } || get($page);
$cache->spew($page_content);

my $html = HTML::TreeBuilder->new_from_content($page_content);
my $vypis = $html->look_down(class => "vypis");
my $galerie = $html->look_down(id => "div_galerie");
my $komentare = $html->look_down(id => "div_komentare");

for ($vypis, $galerie, $komentare) {
    $_->dump;
}
$html->delete;
