
use 5.16.3;
use Tie::IxHash;
use Data::Dump qw(dd);

# hash with ordered keys
tie my %tree, 'Tie::IxHash';

$tree{a} = 10;
$tree{z} = 20;
$tree{b} = 30;

dd \%tree;
dd [keys %tree];
dd [values %tree];
