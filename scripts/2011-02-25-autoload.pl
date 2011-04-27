
use 5.010;

package Proxy::Log;

sub new {
    my ($class, $proxied) = @_;
    bless \$proxied, $class;
}

sub AUTOLOAD {
    my ($name) = our $AUTOLOAD =~ /::(\w+)$/;
    warn "$name: @_";
    my $self = shift;
    return $$self->$name( @_ );
}

package Another;

sub new {
    bless {}, $_[0];
}

sub AnyKindOfSub {
    warn "Target called\n";
    return "Hello";
};


package main;

my $tst = Proxy::Log->new(Another->new);
say $tst->AnyKindOfSub();
