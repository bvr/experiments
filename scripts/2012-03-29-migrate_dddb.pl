use Config::Auto;
use DBI;

my $config = Config::Auto::parse('do_sql.ini');
my $cfg = $config->{fctools6w};

my $dbh = DBI->connect("DBI:mysql:host=$cfg->{serv}", $cfg->{user}, $cfg->{pass});

my $databases = $dbh->selectcol_arrayref("SHOW DATABASES");
for my $db_name (sort @$databases) {
    my $ret1 = $dbh->do("ALTER TABLE $db_name.producedobjects DROP KEY `Unq_Object`");
    my $ret2 = $dbh->do("ALTER TABLE $db_name.producedobjects ADD UNIQUE KEY `Unq_Produce` (`FunctionID`,`ObjectID`)");
    warn join("\t", $db_name, $ret1, $ret2), "\n";
}

$dbh->disconnect();
