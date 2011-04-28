
=head1 The list in DATA section is made by one-liner:

   dir /b/s | grep test_description.txt | perl -nE "chomp; my $t = do {local $/; open my $in,'<',$_ or die qq{$_:$!}; <$in> }; say qq{SRDD_LCT_: $_\n$t};" | grep "SRDD_LCT_" | less

result has been modified by hand.

=cut

my $test, %srdd, %test;
while(<DATA>) {
    chomp;
    $test = $_ if /^TEST/;
    if(s/^\s+//) {
        $srdd{$test} ||= [];
        push @{ $srdd{$test} }, $_;
        $test{$_} ||= [];
        push @{ $test{$_} }, $test;
    }
}

use YAML::Syck;

%test = map {
    ref $test{$_} eq 'ARRAY' && @{$test{$_}} == 1 ? ($_ => $test{$_}[0])
                                                  : ($_ => $test{$_})
} keys %test;
warn Dump \%srdd, \%test;


__DATA__
TEST_01__SKP_NORMAL_RUN
    SRDD_LCT_000006
    SRDD_LCT_000027
    SRDD_LCT_000038
TEST_02__AF_NORMAL_RUN
    SRDD_LCT_000008
    SRDD_LCT_000028
TEST_03__PF_NORMAL_RUN
    SRDD_LCT_000007
    SRDD_LCT_000010
    SRDD_LCT_000021
TEST_04__SP_NORMAL_RUN
    SRDD_LCT_000017
    SRDD_LCT_000026
TEST_05__SYMBOL_OVERLAP
    SRDD_LCT_000015
TEST_06__PROGBITS_DIFFERENCE
    SRDD_LCT_000011
TEST_07__NON_ZERO_PADDING
    SRDD_LCT_000012

