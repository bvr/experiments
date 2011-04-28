

my $foo = qr/(\S+) (\X+)/;
my $bar = '$2';

my $line = "Hello Hey";
$line =~ s/$foo/$bar/gee;
warn $line;
