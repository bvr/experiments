
use Data::Dump;

chomp(my $str = <<'PATH');
\\hydfs00\PUBLIC1\DEV\pkumar\ITT_TEST_BUILD\CS2.1_PROD_TEST_40550_LG_LC_Java_sp36_obfuscated
PATH

dd $str;
