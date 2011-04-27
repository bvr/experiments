use strict; use warnings;
use Time::Piece;

while (<DATA>){
    s{^(\d{2}/\d{2})(\s)}{ "$1/" . localtime->year . $2 }e;
    print;
}

__DATA__
02/04 15:00 Some strings
03/03 15:00 other strings
01/12/2010 12:00 other strings
03/04 15:00 more strings
