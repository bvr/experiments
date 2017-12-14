
use List::MoreUtils 'uniq';
use Data::Dump      'dd';

my @arr = (
    "retazec jedna",
    "retazec dva",
    "retazec dva",
    "retazec jedna",
);

my @filtered = uniq @arr;
dd @filtered;
