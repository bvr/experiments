
use 5.010; use strict; use warnings;
use Win32::Unicode::Native;

binmode STDOUT, ":utf8";
for my $file (@ARGV) {
    open my $in,"<:utf8",$file or die;
    while ( <$in> ) {
        print;
    }
}

my $input = "\x{7ec8}";
print "$input\n";
