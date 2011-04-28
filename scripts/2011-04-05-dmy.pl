
use 5.010;

use Time::Piece;
say localtime->dmy('');     # 05042011

use Time::Piece;
say localtime(0)->dmy('');  # 01011970
