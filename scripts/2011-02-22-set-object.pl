
package My::Set::Object;

use strict;
use warnings;

use Moose;
use Set::Object;

has type => (is => 'ro', isa => 'Str', required => 1);
has _so => (is => 'ro', isa => 'Set::Object', handles => qr/^[a-z]+/, lazy_build => 1);

# before [ qw(insert invert intersection union) ] => sub {
#   my ($self,@list) = @_;
#
#   for (@list) {
#     confess "Only ",$self->type," objects are allowed " unless $_->does($self->type);
#   }
# };

sub _build__so {
  return Set::Object->new()
}
no Moose;
__PACKAGE__->meta->make_immutable;


package main;

my $set = My::Set::Object->new(type => 'Int');

$set->insert(10,20);
warn $_->name,"\n" for $set->meta->get_all_methods;
