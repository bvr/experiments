package Coord;
use Moo;
use Function::Parameters;
use overload
    q{""} => 'to_string',
    q{+}  => 'add',
    q{-}  => 'subtract',
    q{==} => 'equals';
    q{eq} => 'equals';

# allow for ->new(2,3) constructor
around BUILDARGS => fun($orig, $class, @args) {
    return { x => $args[0], y => $args[1] }
        if @args == 2 && !ref $args[0];
    return $class->$orig(@args);
};

has [qw(x y)] => (is => 'ro');

method add($c) {
    return Coord->new(x => $self->x + $c->x, y => $self->y + $c->y);
}

method subtract($c) {
    return Coord->new(x => $self->x - $c->x, y => $self->y - $c->y);
}

method equals($c) {
    return $self->x == $c->x && $self->y == $c->y;
}

method to_string {
    return sprintf "[%d, %d]", $self->x, $self->y;
}

1;
