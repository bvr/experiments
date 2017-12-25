use 5.16.3;
use Test::More;
use Function::Parameters;
use Data::Dump;

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

my %registers = ();
my @code = split /\n/, $input;
my $last_sound = undef;
my $pc = 0;
EXEC: while(defined $code[$pc]) {
    my ($inst, $x, $y) = split /\s+/, $code[$pc];
    # warn "$code[$pc]\n";
    for($inst) {
        when('snd') { $last_sound = reg_value($x); warn "sound ".$last_sound; }
        when('set') { $registers{$x} = reg_value($y); }
        when('add') { $registers{$x} = reg_value($x) + reg_value($y); }
        when('mul') { $registers{$x} = reg_value($x) * reg_value($y); }
        when('mod') { $registers{$x} = reg_value($x) % reg_value($y); }
        when('rcv') { if(reg_value($x) != 0) { warn "recover $last_sound"; last EXEC } }
        when('jgz') { if(reg_value($x) != 0) { $pc += reg_value($y)-1 } }
    }
    # dd \%registers;
    $pc++;
}
is $last_sound, 7071, 'Last sound - part 1';


done_testing;

fun reg_value($reg_or_value) {
    # warn "reg_value $reg_or_value\n";
    return $reg_or_value =~ /^[a-z]$/ ? $registers{$reg_or_value} : $reg_or_value;
}

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
