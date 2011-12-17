my $formatted = sprintf "%.2f", 1/6;     # gives 0.17


for my $file (grep { -f } <D:\\*>) {
    printf "%-40s %10d\n", $file, -s $file;
}
