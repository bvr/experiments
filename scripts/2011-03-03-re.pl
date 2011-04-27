

my $line = "checksession ok:6178 avg:479 avgnet:480 MaxTime:18081 fail1:19";
if(my ($reg_suc, $reg_fail, $addend)
    = $line =~ /^checksession\s+ok:(\d+).*?(fail1:(\d+))?$/
) {
    warn "$reg_suc\n$reg_fail\n$addend\n";
}
