use 5.16.3;
use Test::More;
use Function::Parameters;
use Data::Dump;

package Program {
    use Moo;
    use Function::Parameters;
    use Types::Standard qw(HashRef ArrayRef InstanceOf Enum);

    has id         => (is => 'ro', isa => Enum [qw(0 1)], required => 1);
    has code       => (is => 'ro', isa => ArrayRef,       required => 1);
    has target     => (is => 'rw', isa => InstanceOf ['Program'], writer => 'set_target');
    has _buffer    => (is => 'ro', isa => ArrayRef, default => sub { +[] });
    has registers  => (is => 'lazy', isa => HashRef);
    has pc         => (is => 'rw', writer => 'set_pc', default => 0);
    has last_sound => (is => 'rw', writer => 'set_last_sound', predicate => 1);
    has sent      => (is => 'rwp', default => 0);

    has instruction_set => (is => 'ro', isa => HashRef, default => sub { +{

        snd => method($x) {
            my $vx = $self->value($x);
            $self->set_last_sound($vx);
            $self->inc_sent;
            $self->target->push_to_buffer($vx);
        },
        rcv => method($x) {
            if($self->value($x)) {
                $self->get_from_buffer();
            }
        },

        jgz => method($x, $y) { if($self->value($x)) { $self->set_pc($self->pc + $self->value($y)-1) } },

        set => method($x, $y) { $self->set_register($x, $self->value($y)) },
        add => method($x, $y) { $self->set_register($x, $self->value($x) + $self->value($y)) },
        mul => method($x, $y) { $self->set_register($x, $self->value($x) * $self->value($y)) },
        mod => method($x, $y) { $self->set_register($x, $self->value($x) % $self->value($y)) },
    } });

    method _build_registers {
        return { p => $self->id };
    }

    method step {
        if(! $self->is_done) {
            my ($inst, $x, $y) = split /\s+/, $self->code->[$self->pc];
            my $op = $self->instruction_set->{$inst} or die "Unknown instruction $inst";
            $op->($self, $x, $y);
            $self->set_pc($self->pc + 1);
        }
    }

    method execute {
        while(! $self->is_done) {
            $self->step;
        }
    }

    method is_done {
        return ! ($self->pc >=0 && defined $self->code->[$self->pc]);
    }

    method value($reg_or_value) {
        return $reg_or_value =~ /^[a-z]$/ ? $self->registers->{$reg_or_value} : $reg_or_value;
    }

    method set_register($reg, $value) { $self->registers->{$reg} = $value; }
    method _inc_sent { $self->_set_sent($self->sent + 1); }

    method push_to_buffer($value)     { push @{ $self->_buffer }, $value; }
    method get_from_buffer            { return shift @{ $self->_buffer }; }
}

my $example = <<END;
set a 1
add a 2
mul a a
mod a 5
snd a
set a 0
rcv a
jgz a -1
set a 1
jgz a -2
END

my $input = do { local $/; <DATA> };

{
    my $prog = Program->new(id => 0);
    $prog->execute(split /\n/, $example);
    is $prog->last_sound, 4, 'Example output';
}

{
    my $prog = Program->new(id => 0);
    $prog->execute(split /\n/, $input);
    is $prog->last_sound, 7071, 'Last sound - part 1';
}

done_testing;


=head1 ASSIGNMENT

http://adventofcode.com/2017/day/18

=cut

__DATA__
set i 31
set a 1
mul p 17
jgz p p
mul a 2
add i -1
jgz i -2
add a -1
set i 127
set p 826
mul p 8505
mod p a
mul p 129749
add p 12345
mod p a
set b p
mod b 10000
snd b
add i -1
jgz i -9
jgz a 3
rcv b
jgz b -1
set f 0
set i 126
rcv a
rcv b
set p a
mul p -1
add p b
jgz p 4
snd a
set a b
jgz 1 3
snd b
set f 1
add i -1
jgz i -11
snd a
jgz f -16
jgz a -19
