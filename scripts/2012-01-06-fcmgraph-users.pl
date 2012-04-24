
use lib q'd:\DataDict\DDGraph\SMV\trunk';

use Config::Auto;
use DBI;
use Util::Ldap;

my %config = %{ Config::Auto::parse('do_sql.ini') };
my $cfg = $config{fctools6};

my $db = 'datadict';
my $dbh = DBI->connect("DBI:mysql:$db:" . $cfg->{serv}, $cfg->{user}, $cfg->{pass})
    or die "Connect error: $DBI::errstr";

my $items = $dbh->selectall_arrayref("SELECT UserEID as user FROM users");

for my $row (@$items) {
    my ($user) = @$row;

    $user =~ s/^DD_//i;
    my $ldap = Util::Ldap->new(eid => $user);
    $ldap->_read_ldap_info()
    warn "$user\t".$ldap->user_name."\t".$ldap->user_mail."\n";
}

$dbh->disconnect();

