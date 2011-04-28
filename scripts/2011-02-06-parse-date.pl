
# http://stackoverflow.com/questions/4911939/perl-date-function-module-able-to-understand-full-unabbreviated-months/4912065#4912065

use Time::Piece;
my $dt = Time::Piece->strptime("2 February 1988", "%d %B %Y");
print $dt->ymd,"\n";
