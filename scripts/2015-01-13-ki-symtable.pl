use 5.16.0;

=head2 Info

Analysis of KI300 memory used by its symbols. The textual list of symbols
in __DATA__ section is product of what CMT tool outputs with C<NGCCPU>'s method
C<DumpSymbolTable>. Output writes report sorted by memory location with columns
detailing on symbol name, address, value and sequence relation.

=head2 Output example

    ARINC 429 speed                                     0x8002ad2c  0x0              |
    Battery installed                                   0x8002ad30  0x1              |
    Processing of external attitude                     0x8002ad38  0x1              8
    External attitude identification                    0x8002ad3c  0x0              |
    External Attitude SDI                               0x8002ad40  0x2              |
    Flight director identification                      0x8002ad48  0x0              8
    Flight Director SDI                                 0x8002ad4c  0x1              |
    ARS CPU SW Part Number                              0x8002ad50  0x0              |
    KI 300 identification                               0x8002ad54  0x0              |

=cut

package Symbol {
    use Moo;
    use Function::Parameters;

    has name    => (is => 'ro');
    has address => (is => 'ro');
    has value   => (is => 'ro');
    has cpu     => (is => 'ro');

    method to_string {
        return sprintf("%-50s  0x%x  0x%x", $self->name, $self->address, $self->value);
    }
}

my %symbols = ();
my %find_symbol = ();

my $cpu;
while(<DATA>) {
    chomp;
    if(/(.*) Symbol records/) {
        $cpu = $1;
    }

    if(my ($symbol, $address, $value) = /Symbol: (.*?) \(0x(.*?)\) = (.*)/) {
        die "Symbols must be preceded by \"XXX Symbol records\" line"
            unless $cpu;

        my $sym = Symbol->new(name => $symbol, address => hex($address), value => hex($value), cpu => $cpu);
        push @{ $symbols{$cpu} }, $sym;
        $find_symbol{$symbol} = $sym;
    }
}


for my $cpu (sort keys %symbols) {
    say "$cpu\n", "-" x length($cpu);

    my $addr = 0;
    for my $sym (sort { $a->address <=> $b->address } @{ $symbols{$cpu} }) {
        say sprintf("%-80s %s", $sym->to_string, $addr+4 == $sym->address ? "|" : $sym->address - $addr);
        $addr = $sym->address;
    }
    say "";
}

say "Area: ",
    $find_symbol{'MTE_KI 300 source/destination identifier (SDI)'}->address
  - $find_symbol{'MTE_Digital FD pitch command'}->address;


__DATA__
ARS Symbol records
Symbol: MTE Command (0x8002AC44) = 0
Symbol: MTE Command Status (0x8002AC48) = 0
Symbol: SW Part Number (0x8002A3A8) = 0
Symbol: AHRSdevicePitchOffset (0x8002AD14) = 0
Symbol: AHRSdeviceRollOffset (0x8002AD18) = 0
Symbol: AHRSdeviceYawOffset (0x8002AD1C) = 0
Symbol: Processing of external attitude (0x8002AD38) = 1
Symbol: Autopilot system support (0x8002AD20) = 1
Symbol: Battery installed (0x8002AD30) = 1
Symbol: ARINC 429 speed (0x8002AD2C) = 0
Symbol: ARINC 429 enabled (0x8002AD24) = 0
Symbol: KI 300 source/destination identifier (SDI) (0x8002AD28) = 0
Symbol: KI 300 identification (0x8002AD54) = 0
Symbol: Flight director identification (0x8002AD48) = 0
Symbol: External attitude identification (0x8002AD3C) = 0
Symbol: Fault 05 (0x8002F6C8) = 0
Symbol: Fault 06 (0x8002F6C9) = 0
Symbol: Fault 07 (0x8002F6CA) = 0
Symbol: Fault 08 (0x8002F6CB) = 0
Symbol: Fault 09 (0x8002F6CC) = 0
Symbol: Fault 10 (0x8002F6CD) = 0
Symbol: Fault 11 (0x8002F6CE) = 0
ARS SW Part Number = 0x00000000
Display Sym Address = 0x80091878
DISP Symbol records
Symbol: MTE Command (0x8000EB2C) = 0
Symbol: MTE Command Status (0x8000EB30) = 0
Symbol: SW Part Number (0x8000EA6C) = 0
Symbol: MTE Display CPU SW Part Number (0x8000EB28) = 0
Symbol: MTE Configuration CRC (0x8000EB24) = 0
Symbol: MTE_Decision height alert (0x80255514) = 0
Symbol: Fault 01 (0x8025550C) = 0
Symbol: Fault 02 (0x8025550D) = 0
Symbol: Fault 03 (0x8025550E) = 0
Symbol: Fault 04 (0x8025550F) = 0
Symbol: Fault 05 (0x80255510) = 0

