use strict;
use warnings;
use PPI;

my %sub;
my $Document = PPI::Document->new($ARGV[0]) or die "oops";
for my $sub ( @{ $Document->find('PPI::Statement::Sub') || [] } ) {
    unless ( $sub->forward ) {
        $sub{ $sub->name } = $sub->content;
    }
}

use Data::Dumper;
print Dumper \%sub;
