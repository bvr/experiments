
my $c_code = "/* some comment */";
find_comment($c_code, '/*');
find_comment($c_code, '*');
find_comment($c_code, '*/');

sub find_comment {
    my ($text, $str) = @_;

    my $re = quotemeta $str;
    if($text =~ /$re/) {
        print "found $str in $text\n";
    }
}
