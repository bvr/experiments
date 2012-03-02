
use DBI;

foreach (@{$DBI::EXPORT_TAGS{sql_types}}) {
    printf "%s=%d\n", $_, &{"DBI::$_"};
}
