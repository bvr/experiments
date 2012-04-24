
use Config::Auto;
use DBI;
use Data::Dump qw(pp);

my %config = %{ Config::Auto::parse('do_sql.ini') };
my $cfg = $config{fctools6};

my $db = 'datadict';
my $dbh = DBI->connect("DBI:mysql:$db:" . $cfg->{serv}, $cfg->{user}, $cfg->{pass})
    or die "Connect error: $DBI::errstr";

my %user_exists = map { $_->[0] => 1 } @{ $dbh->selectall_arrayref("SELECT UserEID from datadict.users") };

my $databases = $dbh->selectall_arrayref("SHOW DATABASES");
for my $db_name (sort map { $_->[0] } @$databases) {
    my $found = $dbh->selectall_arrayref("SELECT UserEID FROM $db_name.partition_roles");
    for my $eid (map { $_->[0] } @$found) {
        warn "$db_name\t$eid\n" unless $user_exists{$eid};
    }
}

$dbh->disconnect();

