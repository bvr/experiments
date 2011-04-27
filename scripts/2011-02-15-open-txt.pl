
use strict;

use Win32::OLE;
use Win32::OLE::Const 'Microsoft Excel';
use Data::Dump;     # for dd

Win32::OLE->Option(Warn => 3);

my $Excel = Win32::OLE->new("Excel.Application");

$Excel->Workbooks->OpenText({
    Filename             => 'enter the full path to file',
    Origin               => xlMSDOS,
    StartRow             => 1,
    DataType             => xlDelimited,
    TextQualifier        => xlDoubleQuote,
    Tab                  => "True",
    TrailingMinusNumbers => "True"
});

my $Sheet = $Excel->ActiveWorkbook->Worksheets(1);
my $Data  = $Sheet->UsedRange()->{Value};

dd $Data;


# ----

my $file = 'd:\DataDict\787DD\resources\Utils\PropertiesCSV\multiple.txt';
{
    open my $in,"<",$file or die "$file: $!";
    while(<$in>) {
        chomp;
        my @cols = split /\t/;
        warn @cols;
    }
}
