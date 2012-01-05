
my $out = $condition ? *STDOUT : *STDERR;

warn "ee";
print $out "This should go somewhere\n";
warn "eek";
