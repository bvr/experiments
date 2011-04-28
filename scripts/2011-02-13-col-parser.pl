
# http://stackoverflow.com/questions/4983510/tokenizing-with-perl-and-unstructured-data/4983783#4983783

my @data;

# skip header
my $hdr = <DATA>;
my $sep = <DATA>;

while(<DATA>) {
    chomp;

    # skip empty and total lines
    next if /^\s*$/ || /^[ ]{5}/;

    push @data, [
        map { s/^\s+//; s/\s+$//; $_ }      # trim data
        unpack 'A6A7A7A7 A18A20 A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4A4 A10', $_
    ];
}

use Data::Dump qw{dump};
dump \@data;


__DATA__
CRN SUB      CRSE   SECT   COURSE TITLE         INSTRUCTOR        A   A- B+ B     B- C+ C     C- D+ D     D- F    I   CR NC W     WN INV TOTAL
----- --     ----   ----   -----------------   ----------------- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- -----
33450 XX     9950   AIP    OVERSEAS-AIP SPAI   NOT FOUND                                                               1   1                2
33092 XX     9950   ALB    ddddddd, SPN. vi   NOT FOUND                                                               1                    1
33494 XX     9950   W16    OVERSEAS Univ.Wes   NOT FOUND                                                               1                    1

                           INSTRUCTOR TOTALS NOT FOUND             2                                                1   18   1    2          24
                           PERCENTAGE DISTRI NOT FOUND             8                                                4   75   4    8       ******

33271 PE 3600 001          Global Geography    sfnfbg,dsdassaas        2    2    1    1    2    3    6    5    3    3   1                        29

                           INSTRUCTOR TOTALS snakdi,plid          2    2    1    1    2    3    6    5    3    3   1                        29
                           PERCENTAGE DISTRI krapsta,lalalal          7    7    3    3    7   10   21   17   10   10   3                     ***
