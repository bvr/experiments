use Text::CSV_XS;

my $csv = Text::CSV_XS->new({ binary => 1, sep_char => ';' })
    or die;

my $hdr = $csv->getline(\*DATA);
while (my $row = $csv->getline(\*DATA)) {
    $csv->combine(
        map { $hdr->[0], $row->[0], $hdr->[$_], $row->[$_] } 1..$#$row
    );
    print $csv->string,"\n";
}

__DATA__
id;Column1;column2;column3;columnN
1;apple;Red;Medium;Text1
2;Mango;Yellow;Large;Text2
3;Banana;Yellow;small;Text3
4;Apple;Red;Medium;Text4
5;Pear;Green;Medium;Text5
