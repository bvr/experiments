
use LWP::Simple qw(get);
use JSON qw(from_json);

my $url     = "http://example.com/get/json";
my $decoded = from_json(get($url));
