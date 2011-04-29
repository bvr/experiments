package Gurke;
use Moose;
use Data::Dumper;

has color  => is => 'rw', isa => 'Str', default => 'green';
has length => is => 'rw', isa => 'Num';
has appeal => is => 'rw', isa => 'Any';

around BUILDARGS => sub {
    my $orig   = shift;
    my $class  = shift;
    my %params = ref $_[0] ? %{$_[0]} : @_;

    return $class->$orig(
        map  { $_ => $params{$_} }
        grep { defined $params{$_} }
        keys %params
    );
};

around color => sub {
    # print STDERR Dumper \@_;
    my $orig = shift;
    my $self = shift;
    return $self->$orig unless @_;
    return unless defined $_[0];
    return $self->$orig( @_ );
};

package main;
use Test::More;
use Test::Exception;

my $gu = Gurke->new;
isa_ok $gu, 'Gurke';
diag explain $gu;

ok ! exists $gu->{length}, 'attribute not passed, so not set';

diag q(attempt to set color to undef - we don't want it to succeed);
ok ! defined $gu->color( undef ), 'returns undef';
is $gu->color, 'green', 'value unchanged';

diag q(passing undef in the constructor will make it die);
dies_ok { Gurke->new( color => undef ) }
    'around does not work for the constructor!';
lives_ok { $gu = Gurke->new( appeal => undef ) } 'anything goes';
diag explain $gu;
diag q(... but creates the undef hash key, which is not what I want);
done_testing;
