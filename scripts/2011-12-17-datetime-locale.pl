#!/usr/bin/env perl

# from http://blog.nu42.com/2011/12/how-can-i-print-dates-in-multiple.html

use strict; use warnings;

use DateTime;
use DateTime::Locale;

binmode STDOUT, ':utf8';

my $dt = DateTime->today;
print_date( $dt );

for my $locale ( qw(ar da de en_GB es fr ru tr cs) ) {
    $dt->set_locale( $locale );
    print_date( $dt );
}

sub print_date {
    my ($dt) = @_;
    my $locale = $dt->locale;

    printf(
        "In %s: %s\n", $locale->name,
        $dt->format_cldr($locale->date_format_full)
    );
}
