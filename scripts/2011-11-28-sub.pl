
$s->{passed} = sub { warn "Hi" };

warn ref $s->{passed};

$s->{passed}->();

