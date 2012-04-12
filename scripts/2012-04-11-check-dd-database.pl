use Config::Auto;
use DBI;
use Text::Diff;

my $config = Config::Auto::parse('do_sql.ini');
my $cfg = $config->{fctools6w};

my ($server, $user, $pass) = @{$cfg}{qw(serv user pass)};
my $dbh = DBI->connect("DBI:mysql:host=$server", $user, $pass, { RaiseError => 1});

my $in_aircrafts_table = join "\n", sort
    map {lc}
    @{$dbh->selectcol_arrayref("SELECT db_name FROM datadict.aircrafts")};

my $on_server = join "\n",
    sort grep { !/^(information_schema|datadict|mysql)$/ }
    @{$dbh->selectcol_arrayref("SHOW DATABASES")};

print diff \$in_aircrafts_table, \$on_server, { STYLE => 'Table', CONTEXT => 0 };
