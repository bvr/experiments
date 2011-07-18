
# answer to http://stackoverflow.com/questions/6708473/how-to-extract-text-from-ms-word

use strict; use warnings;

use Win32::OLE qw(in);
use Win32::OLE::Const 'Microsoft Word';

$Win32::OLE::Warn = 3;

my $word = Win32::OLE->new('Word.Application')
    or die "Unable to open document ", Win32::OLE->LastError();

$word->{'Visible'} = 1;

my $doc = $word->Documents->Open({
    FileName           => 'd:\\Test.docx',
    ConfirmConversions => 0,
    AddToRecentFiles   => 0,
    Revert             => 0,
    ReadOnly           => 1,
    OpenAndRepair      => 0,
}) or die "Could not open. Error:", Win32::OLE->LastError();

# print paragraphs
for my $par (in $doc->Paragraphs) {
    print $par->Range->Text();
}

# export as formatted text
$doc->SaveAs({
    FileName   => 'd:\\Test.txt',
    FileFormat => wdFormatEncodedText,
});

$doc->Close({SaveChanges => wdDoNotSaveChanges});
$word->Quit({SaveChanges => wdDoNotSaveChanges});
undef $word;
