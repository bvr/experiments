
while(<DATA>) {
    chomp;
    if(my ($amount,$name) = /^(\d+)(.*)/) {
        print "$name\t$amount\n";
    }
}

__DATA__

#
16Wesley Yi
	4%
#
14Rene Hokans
	4%
