#!usr/bin/perl
# http://stackoverflow.com/questions/5044106/querying-a-website-with-perl-lwpsimple-to-process-online-prices/5044610#5044610

use strict; use warnings;

use LWP::Simple;
use URI::Escape;
use HTML::TreeBuilder;
use Try::Tiny;

my $look_for = "Archer Season 1";

my $contents
    = get "http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords="
    . uri_escape($look_for);

my $html = HTML::TreeBuilder->new_from_content($contents);
for my $item ($html->look_down(id => qr/result_\d+/)) {
    # $item->dump;      # find out structure of HTML
    my $title = try { $item->look_down(class => 'productTitle')->as_trimmed_text };
    my $price = try { $item->look_down(class => 'newPrice')->find('span')->as_text };

    print "$title\n$price\n\n";
}
$html->delete;
