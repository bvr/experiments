use Config::Auto;
use DBI;

my $config = Config::Auto::parse('do_sql.ini');
my $cfg = $config->{fctools6w};

my ($server, $user, $pass) = @{$cfg}{qw(serv user pass)};
my $dbh = DBI->connect("DBI:mysql:host=$server", $user, $pass, { RaiseError => 1});

my %users = map { $_ => 1 }
    @{$dbh->selectcol_arrayref("SELECT UserEID from datadict.users")};

my @db_name_list = sort grep { !/^(datadict|mysql|information_schema)$/ }
    @{$dbh->selectcol_arrayref("SHOW DATABASES")};

for my $db_name (@db_name_list) {

    # fix something
    # $dbh->do("UPDATE $db_name.partition_roles SET UserEID = 'DD_E566173' WHERE UserEID = 'DD_e566173'");

    my $part_roles_users
        = $dbh->selectcol_arrayref("SELECT UserEID FROM $db_name.partition_roles");
    for my $user (@$part_roles_users) {
        unless(defined $users{$user}) {
            warn "$db_name\t$user\n";
        }
    }
}
