
use Mojo::UserAgent;
use DDP;


my $ua = Mojo::UserAgent->new(max_redirects => 5);

my $url = 'http://www.fler.cz/flercore/json/products/2.0/listing?ajax=list&zbozi2=1&_tsmax=1360605026&filters%5Bf12%5D=t&filtersInit%5Bid_scat%5D=4&filtersInit%5Bsupercat%5D=zbozi&filtersInit%5Bid_cat%5D=2&filtersInit%5Bprice_currency%5D=CZK&filtersInit%5Bpag_onpage%5D=100&pag_page%5B=2&filtersInit%5Bsa_a%5D=0';

my $tx = $ua->get($url);
p $tx->res->json;

use Storable;
store $tx->res->json->{items} => 'fler_listing';


# 21690
