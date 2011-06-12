use String::Errf qw(errf);

print errf "This process was started at %{start}t with %{args;argument}n.\n", {
    start => $^T,
    args  => 0 + @ARGV
};
