
# Quick utility to get real names of DNS aliased servers and their ip

my @servers = qw(
    machine1
    machine2
    ...
);

for my $srv (@servers) {
    my $out = `tracert -h 1 $srv`;
    my ($name, $ip) = $out =~ /Tracing route to (.*?) \[(.*?)\]/s;
    print join("\t", $srv, $name, $ip), "\n";
}
