
# from http://blogs.perl.org/users/brian_d_foy/2012/04/painless-rss-processing-with-mojo.html

use Mojo::UserAgent;

my $ua       = Mojo::UserAgent->new;
my $response = $ua->get($feed_address)->res;

my @links =
    $response->dom('item')
        ->grep(sub { $_->children('title') !~ /.../ })
        ->map( sub { $_->children('guid')->map(sub { $_->text }); })
        ->each;
