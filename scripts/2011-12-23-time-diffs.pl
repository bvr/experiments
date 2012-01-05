
# answer to http://stackoverflow.com/questions/8619236/difference-of-time-between-two-lines-of-a-log-file

use Time::Piece;

my $lasttime;
while(<DATA>) {
    chomp;

    my $diff;
    if(m{(\d+/\d+/\d+ \d+:\d+:\d+)}) {
        my $t = Time::Piece->strptime($1, "%D %H:%M:%S");
        if(defined $lasttime) {
            $diff = $t - $lasttime;
        }
        $lasttime = $t;
    }
    undef $lasttime if /Finished inserting data/;

    print "$_\t", ($diff && $diff->pretty) , "\n";
}

__DATA__
~
Other Stuff
~
12/21/11 18:58:15 Inserting data into ST_ITEMS
ST_ITEMS Row: 10000 inserted at 12/21/11 19:40:06
ST_ITEMS Row: 20000 inserted at 12/21/11 20:05:58
ST_ITEMS Row: 30000 inserted at 12/21/11 20:37:03
ST_ITEMS Row: 40000 inserted at 12/21/11 20:59:25
ST_ITEMS Row: 50000 inserted at 12/21/11 21:17:43
ST_ITEMS Row: 60000 inserted at 12/21/11 21:54:47
12/21/11 21:59:24 Finished inserting data into  Staging Tables

~
Other Stuff
~

12/21/11 22:04:43 Inserting data into ST_ITEMS
ST_ITEMS Row: 10000 inserted at 12/21/11 22:38:53
ST_ITEMS Row: 20000 inserted at 12/21/11 23:06:33
ST_ITEMS Row: 30000 inserted at 12/21/11 23:33:03
ST_ITEMS Row: 40000 inserted at 12/22/11 00:05:38
ST_ITEMS Row: 50000 inserted at 12/22/11 00:45:59
ST_ITEMS Row: 60000 inserted at 12/22/11 01:12:42
ST_ITEMS Row: 70000 inserted at 12/22/11 01:40:02
ST_ITEMS Row: 80000 inserted at 12/22/11 02:14:23
ST_ITEMS Row: 90000 inserted at 12/22/11 03:04:15
ST_ITEMS Row: 100000 inserted at 12/22/11 03:47:13
ST_ITEMS Row: 110000 inserted at 12/22/11 04:36:21
ST_ITEMS Row: 120000 inserted at 12/22/11 05:44:47
ST_ITEMS Row: 130000 inserted at 12/22/11 06:28:24
ST_ITEMS Row: 140000 inserted at 12/22/11 07:10:55
ST_ITEMS Row: 150000 inserted at 12/22/11 07:35:16
12/22/11 07:40:28 Finished inserting data into  Staging Tables

~
Other Stuff
~

