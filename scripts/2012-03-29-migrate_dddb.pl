use Config::Auto;
use DBI;

my %config = %{ Config::Auto::parse('do_sql.ini') };
my $cfg = $config{fctools6w};

my $db = 'datadict';
my $dbh = DBI->connect("DBI:mysql:$db:" . $cfg->{serv}, $cfg->{user}, $cfg->{pass})
    or die "Connect error: $DBI::errstr";

my $databases = $dbh->selectall_arrayref("SHOW DATABASES");
for my $db_name (sort map { $_->[0] } @$databases) {
    my $ret1 = $dbh->do("ALTER TABLE $db_name.producedobjects DROP KEY `Unq_Object`");
    my $ret2 = $dbh->do("ALTER TABLE $db_name.producedobjects ADD UNIQUE KEY `Unq_Produce` (`FunctionID`,`ObjectID`)");
    warn join("\t", $db_name, $ret1, $ret2), "\n";
}

$dbh->disconnect();
