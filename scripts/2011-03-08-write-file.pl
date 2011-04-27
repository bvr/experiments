
my $pdf_data = 'contents of PDF ...';
open $ofh, '>:raw', 'output.pdf'
    or die "Could not write: $!";
print {$ofh} $pdf_data;
close $ofh;
