
use DBI;

# configuration
my %mysql = (
    server => "localhost",
    user   => 'root',
    pass   => '',
);

# connect into given database
$dm = DBI->connect("DBI:mysql:host=$mysql{server}",$mysql{user},$mysql{pass})
    or die("Connect error: $DBI::errstr");

warn $dm->quote("O'Rourke, Ken (FC CoE)"),"\n";

# disconnect from database
$dm->disconnect();

__END__
SELECT ID FROM employees WHERE fullName = 'O\'Rourke, Ken (FC CoE)'
