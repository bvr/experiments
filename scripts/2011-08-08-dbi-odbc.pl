
use DBI;

my $host     = 'amber';
my $database = 'assignmentdb';
my $user     = 'something';
my $auth     = 'something';

my $dsn = "dbi:ODBC:Driver={SQL Server};Server=$host;Database=$database";
my $dbh = DBI->connect($dsn, $user, $auth, { RaiseError => 1 });

# .... work with the handle

$dbh->disconnect;
