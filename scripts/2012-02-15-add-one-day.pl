
use Time::Piece;
use Time::Seconds;

my $entered_date = "2011-11-30";
my $date = Time::Piece->strptime($entered_date, "%Y-%m-%d");
$date += ONE_DAY;
warn $date->strftime("%Y-%m-%d");


