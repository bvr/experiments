
use Mojo::URL;
use Data::Dump;

my $url_str = 'http://redir.netcentrum.cz/?noaudit&url=https%3A%2F%2Fapp%2Eliquidplanner%2Ecom%2Fp%2Fa%2F391905%2F8e33338ad0be2db875f69e886f39ab7fdaabb925';

my $url = Mojo::URL->new($url_str);

dd $url->query->to_hash;
