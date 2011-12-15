use feature qw( say );

use Config      qw( %Config );
use Devel::Peek qw( Dump );

my @a = unpack "d5", pack "d5", 255,123,0,45,123;

say 0+@a;             # 5
Dump $a[0];           # NOK (floating point format)
say $Config{nvsize};  # 8 byte floats on this build

