
package CORDx;
use Moose;

use Carp;

sub parse_log {
    my ($self,$input_name, $whatever) = @_;
    open my $fh, "<", $input_name
        or croak "\"$input_name\" not found";

    while(<$fh>) {
        if(/(\S+)\s+(\d+)/) {
            print "$1-$2";
        }
    }
}


package main;

my $cordr = CORDx->new();
$cordr->parse_log('input.txt');
