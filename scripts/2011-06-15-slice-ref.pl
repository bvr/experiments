
# slice from arrayref

my $params = {
    oldDB_Name => 'old',
    newDB_Name => 'new',
};

my ($old, $new) = @{$params}{'oldDB_Name','newDB_Name'};
use Data::Dump;
dd $old, $new;

