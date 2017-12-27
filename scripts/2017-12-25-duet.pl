use 5.16.3;
use Test::More;
use Function::Parameters;
use List::AllUtils qw(any all);
use Data::Dump;

package Program {
    use Moo;
    use Function::Parameters;
    use Types::Standard qw(HashRef ArrayRef InstanceOf Enum);
    use Data::Dump qw(pp);

    has id         => (is => 'ro', isa => Enum [qw(0 1)], required => 1);
    has code       => (is => 'ro', isa => ArrayRef,       required => 1);
    has target     => (is => 'rw', isa => InstanceOf ['Program'], writer => 'set_target', predicate => 1);
    has _buffer    => (is => 'ro', isa => ArrayRef, default => sub { +[] });
    has registers  => (is => 'lazy', isa => HashRef);
    has pc         => (is => 'rw', writer => 'set_pc', default => 0);
    has last_sound => (is => 'rw', writer => 'set_last_sound', predicate => 1);
    has num_sent   => (is => 'rwp', default => 0);
    has waiting    => (is => 'rwp', default => 0);

    has instruction_set => (is => 'ro', isa => HashRef, default => sub { +{

        snd => method($x) {
            my $vx = $self->value($x);
            # warn "snd $vx from ".$self->id."\n";
            $self->set_last_sound($vx);
            $self->_inc_num_sent;
            if($self->has_target) {
                $self->target->push_to_buffer($vx);
            }
        },
        rcv => method($x) {
            if(! $self->has_target) {
                if($self->value($x)) {
                    $self->set_pc(-2);      # terminate run
                    return;
                }
            }
            else {
                # warn "rcv $x in ".$self->id."\n";
                if($self->buffer_empty) {
                    $self->_set_waiting(1);
                    $self->set_pc($self->pc - 1);       # stay on current instruction
                }
                else {
                    $self->set_register($x, $self->get_from_buffer());
                }
            }
        },

        jgz => method($x, $y) { if($self->value($x) > 0) { $self->set_pc($self->pc + $self->value($y)-1) } },

        set => method($x, $y) { $self->set_register($x, $self->value($y)) },
        add => method($x, $y) { $self->set_register($x, $self->value($x) + $self->value($y)) },
        mul => method($x, $y) { $self->set_register($x, $self->value($x) * $self->value($y)) },
        mod => method($x, $y) { $self->set_register($x, $self->value($x) % $self->value($y)) },
    } });

    method _build_registers {
        return { p => $self->id };
    }

    method step {
        if($self->waiting) {
            return if $self->buffer_empty;

            # value arrived
            $self->_set_waiting(0);
        }
        if(! $self->is_done) {
            my ($inst, $x, $y) = split /\s+/, $self->code->[$self->pc];
            my $op = $self->instruction_set->{$inst} or die "Unknown instruction $inst";
            # warn "[".$self->id."] ".$self->pc . ": $inst $x ".(defined $y ? $y : "")." ".pp($self->registers)."\n";
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
        return $reg_or_value =~ /^[a-z]$/ ? ($self->registers->{$reg_or_value} // 0) : $reg_or_value;
    }

    method set_register($reg, $value) { $self->registers->{$reg} = $value; }
    method _inc_num_sent              { $self->_set_num_sent($self->num_sent + 1); }

    method push_to_buffer($value)     { push @{ $self->_buffer }, $value; }
    method get_from_buffer            { return shift @{ $self->_buffer }; }
    method buffer_empty               { return @{ $self->_buffer } == 0; }
}

my $example = [ split /\n/, <<END ];
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

my $example2 = [ split /\n/, <<END ];
snd 1
snd 2
snd p
rcv a
rcv b
rcv c
rcv d
END

my $input = [ split /\n/, do { local $/; <DATA> } ];

{
    my $prog = Program->new(id => 0, code => $example);
    $prog->execute();
    is $prog->last_sound, 4, 'Example output';
}

{
    my $prog = Program->new(id => 0, code => $input);
    $prog->execute();
    is $prog->last_sound, 7071, 'Last sound - part 1';
}

{
    my $p0 = Program->new(id => 0, code => $example2);
    my $p1 = Program->new(id => 1, code => $example2);
    $p0->set_target($p1);
    $p1->set_target($p0);

    while(1) {
        last if any { $_->is_done } $p0, $p1;
        last if all { $_->waiting } $p0, $p1;
        $p0->step();
        $p1->step();
    }
    is $p1->num_sent, 3, 'How many times did program 1 send a value - example for part 2';
}

{
    my $p0 = Program->new(id => 0, code => $input);
    my $p1 = Program->new(id => 1, code => $input);
    $p0->set_target($p1);
    $p1->set_target($p0);

    while(1) {
        last if any { $_->is_done } $p0, $p1;
        last if all { $_->waiting } $p0, $p1;
        $p0->step();
        $p1->step();
    }
    is $p1->num_sent, 8001, 'How many times did program 1 send a value - part 2';
}

done_testing;


=head1 ASSIGNMENT

http://adventofcode.com/2017/day/18

=head2 --- Day 18: Duet ---

You discover a tablet containing some strange assembly code labeled
simply "Duet". Rather than bother the sound card with it, you decide to run the
code yourself. Unfortunately, you don't see any documentation, so you're left
to figure out what the instructions mean on your own.

It seems like the assembly is meant to operate on a set of registers that are
each named with a single letter and that can each hold a single integer. You
suppose each register should start with a value of 0.

There aren't that many instructions, so it shouldn't be hard to figure out what
they do. Here's what you determine:

=over

=item * snd X plays a sound with a frequency equal to the value of X.

=item * set X Y sets register X to the value of Y.

=item * add X Y increases register X by the value of Y.

=item * mul X Y sets register X to the result of multiplying the value contained in register X by the value of Y.

=item * mod X Y sets register X to the remainder of dividing the value contained in register X by the value of Y (that is, it sets X to the result of X modulo Y).

=item * rcv X recovers the frequency of the last sound played, but only when the value of X is not zero. (If it is zero, the command does nothing.)

=item * jgz X Y jumps with an offset of the value of Y, but only if the value of X is greater than zero. (An offset of 2 skips the next instruction, an offset of -1 jumps to the previous instruction, and so on.)

=back

Many of the instructions can take either a register (a single letter) or a
number. The value of a register is the integer it contains; the value of a
number is that number.

After each jump instruction, the program continues with the instruction to
which the jump jumped. After any other instruction, the program continues with
the next instruction. Continuing (or jumping) off either end of the program
terminates it.

For example:

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

=over

=item * The first four instructions set a to 1, add 2 to it, square it, and then set it to itself modulo 5, resulting in a value of 4.

=item * Then, a sound with frequency 4 (the value of a) is played.

=item * After that, a is set to 0, causing the subsequent rcv and jgz instructions to both be skipped (rcv because a is 0, and jgz because a is not greater than 0).

=item * Finally, a is set to 1, causing the next jgz instruction to activate, jumping back two instructions to another jump, which jumps again to the rcv, which ultimately triggers the recover operation.

=back

At the time the recover operation is executed, the frequency of the last sound played is 4.

What is the value of the recovered frequency (the value of the most recently
played sound) the first time a rcv instruction is executed with a non-zero
value?

Your puzzle answer was 7071.

--- Part Two ---

As you congratulate yourself for a job well done, you notice that the
documentation has been on the back of the tablet this entire time. While you
actually got most of the instructions correct, there are a few key differences.
This assembly code isn't about sound at all - it's meant to be run twice at the
same time.

Each running copy of the program has its own set of registers and follows the
code independently - in fact, the programs don't even necessarily run at the
same speed. To coordinate, they use the send (snd) and receive (rcv)
instructions:

=over

=item * snd X sends the value of X to the other program. These values wait in a queue until that program is ready to receive them. Each program has its own message queue, so a program can never receive a message it sent.

=item * rcv X receives the next value and stores it in register X. If no values are in the queue, the program waits for a value to be sent to it. Programs do not continue to the next instruction until they have received a value. Values are received in the order they are sent.

=back

Each program also has its own program ID (one 0 and the other 1); the register
p should begin with this value.

For example:

    snd 1
    snd 2
    snd p
    rcv a
    rcv b
    rcv c
    rcv d

Both programs begin by sending three values to the other. Program 0 sends 1, 2,
0; program 1 sends 1, 2, 1. Then, each program receives a value (both 1) and
stores it in a, receives another value (both 2) and stores it in b, and then
each receives the program ID of the other program (program 0 receives 1;
program 1 receives 0) and stores it in c. Each program now sees a different
value in its own copy of register c.

Finally, both programs try to rcv a fourth time, but no data is waiting for
either of them, and they reach a deadlock. When this happens, both programs
terminate.

It should be noted that it would be equally valid for the programs to run at
different speeds; for example, program 0 might have sent all three values and
then stopped at the first rcv before program 1 executed even its first
instruction.

Once both of your programs have terminated (regardless of what caused them to
do so), how many times did program 1 send a value?

Your puzzle answer was 8001.

Both parts of this puzzle are complete! They provide two gold stars: **

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
