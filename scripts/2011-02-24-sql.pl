
use DBI;

$dbh = DBI->connect("DBI:mysql:....",$user,$pass)
    or die("Connect error: $DBI::errstr");

my $sth = $dbh->prepare(qq{ SELECT something FROM table WHERE name = ? });
$sth->execute('the gambia');

# fetch data from $sth

$dbh->disconnect();

