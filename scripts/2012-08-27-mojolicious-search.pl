use Mojo::UserAgent;

Mojo::UserAgent->new->get('http://www.google.com/search?q=mojolicious')
   ->res->dom->find('h3.r a')
   ->each( sub { print shift->all_text . "\n" } );
