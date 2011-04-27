my @list_of_files = ("input1.txt", "input2.txt", "input3.txt");

my @lines_in_file = ();                 # target array
for my $file (@list_of_files) {
    open(my $in,'<',$file) or die "can't open $file : $!";

    my $lines = [];                     # scalar containing arrayref
    while(defined ($input = <$in>)) {
        if($input =~ /important/) {
            push @$lines, $input;       # push into arrayref
        }
    }
    close $in;

    push @lines_in_file, $lines;        # push arrayref into main array
}
