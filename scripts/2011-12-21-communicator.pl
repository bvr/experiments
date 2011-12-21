
use Win32::OLE qw(in);
use Win32::OLE::Const 'Microsoft Office Communicator';
use Data::Dump;

sub by {
    my $prop = shift;
    return $a->$prop() cmp $b->$prop();
}

binmode STDOUT => ':utf8';

my $comm = Win32::OLE->new('Communicator.UIAutomation') or die;

my $count = 10;
for my $contact (sort { by 'FriendlyName' } in $comm->MyContacts) {
    print $contact->FriendlyName, "\n";
    last if $count-- == 0;
}

my $c1 = $comm->GetContact('roman.hubacek@honeywell.com', $comm->MyServiceId);
print $c1->Status, "\n";

dd [
    MISTATUS_UNKNOWN,
    MISTATUS_ONLINE,
    MISTATUS_INVISIBLE,
    MISTATUS_BUSY,
    MISTATUS_AWAY,
];

