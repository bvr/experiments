
my @part = (
    'http://example.net/app',
    ( 'admin'  ) x!! $is_admin_link,
    ( $subsite ) x!! defined $subsite,
    $mode,
    ( $id      ) x!! defined $id,
    ( $submode ) x!! defined $submode,
);

