
use Win32::Console::ANSI;
use Data::Difflet;

my $difflet = Data::Difflet->new();
print $difflet->compare(
    {   a => 2,
        c => 5,
    },
    {   a => 3,
        b => 4,
    });
