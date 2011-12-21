
use File::Copy;
use File::Find;
use File::Path;
use File::Basename;

my @files = ();
find(sub { push @files,$File::Find::name; },
    "D:\\prog\\perl",
    "C:\\Program Files\\SMV\\perl"
);
my %real_names = map { tr{/}{\\}; lc$_ => $_ } @files;

my %paths = ();

for my $log_filename (<*.CSV>) {
    open(my $I, $log_filename);
    my $heading = <$I>;
    while(<$I>) {
        chomp;
        tr{"}{}d;
        $paths{$_} = -s $_
            if -e $_;
    }
    close($I);
}

for(sort keys %paths) {
    my $real_name = $real_names{lc $_};
    warn "$real_name\t$paths{$_}\n";
    die "$_" unless defined $real_name;

    my $target = $real_name;
    $target =~ s{^D:\\prog\\Perl\\}{D:\\small_perl\\}i;
    if(-d) { mkpath($target); }
    else   {
        my $dir = dirname($target);
        mkpath($dir) if ! -d $dir;
        copy($real_name,$target) or warn "Copy failed: $!";
    }
    $count += $paths{$_};
}
print "Total: $count\n";
