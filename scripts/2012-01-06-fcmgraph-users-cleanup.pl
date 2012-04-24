
use Config::Auto;
use DBI;
use Data::Dump qw(pp);

my %config = %{ Config::Auto::parse('do_sql.ini') };
my $cfg = $config{fctools6w};

my $db = 'datadict';
my $dbh = DBI->connect("DBI:mysql:$db:" . $cfg->{serv}, $cfg->{user}, $cfg->{pass})
    or die "Connect error: $DBI::errstr";

my @removed_users = do {
    open my $in, '<', q'd:\DataDict\DDGraph\resources\sql\removed_users.txt' or die;
    map { chomp; s/\t.*$//; "DD_$_" } <$in>
};
my $rem_user_str = '(' . join(', ', map { "'$_'" } @removed_users) . ')';

my $databases = $dbh->selectall_arrayref("SHOW DATABASES");
for my $db_name (sort map { $_->[0] } @$databases) {
    my $ret = $dbh->do("DELETE FROM $db_name.partition_roles WHERE UserEID in $rem_user_str");
    warn "$db_name\t$ret\n";
}

$dbh->disconnect();

