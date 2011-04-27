
# http://stackoverflow.com/questions/5221613/perl-string-formatting/5221711#5221711

my $input = '[ Move ] [ Source ] [ Destination ]';
my ($mov, $src, $dst) = $input =~ /\[ \s* (.*?) \s* \]/gx;
print "$mov $src $dst\n";
