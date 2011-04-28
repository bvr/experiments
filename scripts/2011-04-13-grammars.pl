use 5.010; use strict;
use Regexp::Grammars;
use Data::Dump qw(dd);

my $input
    = "s(job_name1) or s(job_name2) or s(job_name3) and s(job_name4)";

my $re = qr{
    <[token]> ** <[sep]>
    <rule: token>     s\(<MATCH= ([^)]*) >\)
    <rule: sep>       (and|or)
}xi;

*result = */;
dd @main::result{qw(token sep)}
    if $input =~ $re;

# prints
# (
#   ["job_name1", "job_name2", "job_name3", "job_name4"],
#   ["or", "or", "and"],
# )

