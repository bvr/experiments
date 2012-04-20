
my $line = 'ahoj nazdar cau zdar 10';
my (%info, $date);

(@info{qw(hello hi ciao greetings)}, $date) = split /\s+/, $line;

use Data::Dump;
dd \%info, $date;

