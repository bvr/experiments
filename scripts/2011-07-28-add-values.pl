
my $entry = "First is 10, seconds is 48";
if(my ($a,$b) = $entry =~ /(\d+)/g) {
    print $a + $b,"\n";     # 58
}
