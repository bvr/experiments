
my $data = do {
    open my $in, "<", "file.txt" or die "Could not open: $!";
    local $/;
    <$in>
};

if($data =~ /working/) {
    system("cmd", "/c batch.cmd");
}
