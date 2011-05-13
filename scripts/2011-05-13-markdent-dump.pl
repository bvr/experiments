
# how to see events generated from markdent

use 5.010; use strict; use warnings;

use Markdent::Parser;
use Markdent::Handler::MinimalTree;
use Tree::Simple::View::ASCII;
use Data::Dump qw(pp);

my $markdown = <<END;
## Element `Products`

A container for `Product` elements.

## Element `Product`

Element describing the product for which the set of constants is applicable.

### Attribute `ID`

Product ID used in the *Constant Data Definition* files.

### Attribute `Name`

Name of the product. There should be some strict rules associated with this as
the name may be used in various prefixes or postfixes. It would be reasonable
to require that the name forms a valid identifier.

END

my $handler = Markdent::Handler::MinimalTree->new;
my $parser  = Markdent::Parser->new(dialect => 'Theory', handler => $handler);
$parser->parse(markdown => $markdown);

my $tree_view = Tree::Simple::View::ASCII->new(
    $handler->tree(),
    node_formatter => sub {
        my $node = $_[0]->getNodeValue;
        if(defined $node->{text} && length($node->{text}) > 20) {
            $node->{text} = substr($node->{text},0,20) . "...";
        }
        pp($node);
    }
);
print $tree_view->expandAll();
