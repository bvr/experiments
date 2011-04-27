
# -*- coding: utf-8 -*-

use utf8;
use Win32::OLE qw(CP_UTF8);
use Win32::OLE::Const 'Microsoft Excel';

Win32::OLE->Option(CP => CP_UTF8);

my $excel = Win32::OLE->new('Excel.Application') or die $!;
$excel->{Visible} = 1;

my $wb    = $excel->Workbooks->Add;
my $sheet = $wb->Sheets(1);

$sheet->Range('A1')->{Value} = 'Nějaký český text ďťň';
