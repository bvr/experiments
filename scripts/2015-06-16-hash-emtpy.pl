
my $xyz = {};

sub returns_hashref {
    return {};
}

warn %{returns_hashref()} ? "Hash full" : "empty";
warn %$xyz ? "Hash full" : "empty";
