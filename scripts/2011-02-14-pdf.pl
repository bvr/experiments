
use PDF::API2;
use POSIX qw(setsid strftime);

my $filename = scalar(strftime('%F', localtime));

my $pdf = PDF::API2->new(-file => "$filename.pdf");
$pdf->mediabox(595, 842);
my $page = $pdf->page;
my $fnt  = $pdf->corefont('Arial', -encoding => 'latin1');
my $txt  = $page->text;
$txt->textstart;
$txt->font($fnt, 20);
$txt->translate(100, 800);
$txt->text("Lines for $filename");

my $i    = 0;
my $line = 780;
while ($i < 310) {
    if (($i % 50) == 0) {
        $page = $pdf->page;
        $fnt  = $pdf->corefont('Arial', -encoding => 'latin1');
        $txt  = $page->text;
        $line = 780;
    }
    $txt->font($fnt, 10);
    $txt->translate(100, $line);
    $txt->text("$i This is the first line");
    $line = $line - 15;
    $i++;
}
$txt->textend;
$pdf->save;
$pdf->end();
