
use 5.16.3;
use Mojo::UserAgent;

# download list of trac tickets as a CSV format
my $login    = 'user:pwd';
my $trac_url = 'fctools-scm.honeywell.com/trac/DDGraph';

my $ua = Mojo::UserAgent->new(max_redirects => 5);
$ua->get('https://' . $login . '@' . $trac_url . '/login');
my $tx = $ua->get('https://' . $trac_url . '/query?status=!closed&format=csv&order=id');

if (my $res = $tx->success) {
    say $res->body;
}
else {
    my $err = $tx->error;
    die "$err->{code} response: $err->{message}" if $err->{code};
    die "Connection error: $err->{message}";
}
