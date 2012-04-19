
use strict; use warnings;
use Win32::Clipboard;

my $in = \*DATA;
if(my $file = shift) {
    open $in, "<", $file or die "$file: $!";
}

my $out_str = '';
while(<$in>) {
    chomp;
    if(my ($text, $id) = / = \s*"([^"]*\\([^\\]*))"/) {
        $out_str .= "$id\t$text\n";
    }
}

Win32::Clipboard->Set($out_str);

__DATA__
    ftdSignalArr(0)  = "FCM2A\fcm\canprocoutelev\Inputs\selectedCas"
    ftdSignalArr(1)  = "NI-CAN\Can 3\PITCH_PACE_EP\PACE_PE_COM_6\Sec_CAN_Bus_Sel"
    ftdSignalArr(2)  = "FCM2A\fcm\canprocoutelev\Outputs\onGroundElev"                             'Corrupted Discrete FTCM Signals used in FTD plot
    ftdSignalArr(3)  = "NI-CAN\Can 4\FCM\FCM_PE_COM_0\FCM_On_Ground"                      'Crosslane Discrete FTCM + NI-CAN Signals used in FTD plot
