
use Google::Search;

my $search = Google::Search->Web(query => "perl");
while (my $result = $search->next) {
    print $result->rank, " ", $result->uri, "\n";

    last if $result->rank > 10;
}
