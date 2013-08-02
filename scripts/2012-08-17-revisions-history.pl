
use strict;
use Text::Trim;

my $current;
my %revs;
while(<DATA>) {
    chomp;
    if(/^Revision: (\d+)/) {
        $current = $revs{$1} = {};
    }
    if($a = /^Message:/ .. /----/) {
        $current->{message} .= "$_\n"
            if $a != 1 && $a !~ /E0$/;
    }
}

for(sort keys %revs) {
    my $msg = trim($revs{$_}{message});
    $msg =~ s/\n/[[BR]]/g;
    print "(In [$_]) $msg\n\n";
}

__DATA__
Revision: 4281
Author: Pavel Hynek
Date: Thursday, August 16, 2012 4:13:57 PM
Message:
Some fixes as a result of the repo reorg

----
Modified : /CDBTools/CDBG/trunk/cdbg.pl
Modified : /CDBTools/CDBG/trunk/hafcdb.pl
Modified : /CDBTools/CDBG/trunk/cdbg.perlapp
Modified : /CDBTools/CDBG/trunk/hafcdb.perlapp
Modified : /CDBTools/CDBG/trunk/to_do_list.txt
Modified : /CDBTools/CDBG/trunk/cdb2txt.pl
Added : /CDBTools/CDBG/trunk/deps.pl
Modified : /CDBTools/CDBG/trunk/doc/cdbg_erd.pdf
Modified : /CDBTools/CDBG/trunk/doc/cdbg_erd.pl
Modified : /CDBTools/CDBG/trunk/hafdevcdb.pl
Modified : /CDBTools/CDBG/trunk/t/TEST_FILE.xls
Added : /CDBTools/CDBG/trunk/t/update_dep.t

Revision: 4280
Author: Pavel Hynek
Date: Monday, August 13, 2012 2:24:31 PM
Message:

----
Deleted : /CDBTools/CDBG/trunk/CDB

