
use DateTime;

my $start = DateTime->now->subtract(days => 1)
                ->set(hour => 0, minute => 0, second => 0);
my $end   = $start->clone()->add(days => 1, seconds => -1);

print $start,       " - ",$end,"\n";            # 2011-03-15T00:00:00 - 2011-03-15T23:59:59
print $start->epoch," - ",$end->epoch,"\n";     # 1300147200 - 1300233599

