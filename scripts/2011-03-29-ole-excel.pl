
use strict; use warnings;
use Win32::OLE;
use Win32::OLE::Const 'Microsoft Excel';

my $Excel = Win32::OLE->new('Excel.Application','Quit');
my $Book  = $Excel->Workbooks->Open("C:\\test.xls");
$Book->PublishObjects->Add(xlSourceRange,
    "C:\\output_file.htm", "List1", '$C$3:$C$10', xlHtmlStatic
)->Publish(1);
$Book->Close(0);
$Excel->Quit;
