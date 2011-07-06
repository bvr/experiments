
package TriggerTest;
use Moose;
use Data::Dump;

has item => (is => 'rw', trigger => \&trigger, writer => 'set_item');

sub trigger {
    my ($self, $value, $orig) = @_;
    dd $value, $orig;
}

package main;

my $tt = TriggerTest->new(item => 10);
$tt->set_item(11);
