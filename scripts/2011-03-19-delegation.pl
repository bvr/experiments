
    package Rectangle;
    use Mouse;
    has [ qw( x y ) ], is => 'ro', isa => 'Int';

    sub area {
        my( $self ) = @_;
        return $self->x * $self->y;
    }

    package Square;
    use Mouse;
    has x => is => 'ro', isa => 'Int';
    has rectangle =>
        is => 'ro',
        isa => 'Rectangle',
        lazy_build => 1,
        handles => [ 'area' ];

    sub _build_rectangle {
        my $self = shift;
        Rectangle->new(x => $self->x, y => $self->x);
    }

package main;
use strict;
my $x = shift || 3;
my $y = shift || 7;
my $r = Rectangle->new( x => $x, y => $y);
my $sq1 = Square->new( x => $x );
my $sq2 = Square->new( x => $y );
print $_->area, "\n" for $r, $sq1, $sq2;

