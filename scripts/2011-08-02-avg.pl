

# claimed to have better precision
sub avg_ikegami {
    my $avg;
    $avg += $_/@_ for @_;
    return $avg;
}

# fails with no arguments (divison by zero)
sub avg_davido  {
    my $total;
    $total += $_ foreach @_;
    # sum divided by number of components.
    return $total / @_;
}

