
use 5.10.1;

my @transitions = ();
while(<DATA>) {
    chomp;
    next if /\.(operations|permissions|default|name)/;
    my ($state, $trans) = split /\s* = \s*/x;
    my ($from, $to)     = split /\s* -> \s*/x, $trans;
    for my $fm (split /\s*,\s*/, $from) {
        push @transitions, "\"$fm\" -> \"$to\"";
    }
}

use Data::Dump;
for my $t (@transitions) {
    say $t;
}


__DATA__
 accept = new -> analysis
 accept.operations = set_owner_to_self
 accept.permissions = TICKET_MODIFY
 accept.default = 11

 leave = * -> *
 leave.default = 20
 leave.operations = leave_status

 analysis = new,analysis -> analysis
 analysis.operations = set_owner
 analysis.permissions = TICKET_MODIFY
 analysis.default = 10

 approve = analysis,approve,release -> approve
 approve.operations = set_owner
 approve.permissions = TICKET_MODIFY
 approve.name = approval required
 approve.default = 9

 in_work = analysis,approve,need_info,in_work -> in_work
 in_work.operations = set_owner
 in_work.permissions = TICKET_MODIFY
 in_work.default = 11

 need_info = review,test,in_work,need_info,analysis,re_work -> need_info
 need_info.operations = set_owner
 need_info.permissions = TICKET_MODIFY
 need_info.name = need_info
 need_info.default = 3

 merge = test,merge -> merge
 merge.operations = set_owner
 merge.permissions = TICKET_MODIFY
 merge.default = 5

 release_test = review,merge,need_info,release_test -> release_test
 release_test.operations = set_owner
 release_test.permissions = TICKET_MODIFY
 release_test.default = 8

 release = review,test,release_test,release -> release
 release.operations = set_owner
 release.permissions = TICKET_MODIFY
 release.default = 8

 review = in_work,need_info,review,re_work -> review
 review.operations = set_owner
 review.permissions = TICKET_MODIFY
 review.default = 9

 test = in_work,review,need_info,test,re_work -> test
 test.operations = set_owner
 test.permissions = TICKET_MODIFY
 test.default = 8

 re_work = review,test,release_test,re_work,need_info,verify -> re_work
 re_work.operations = set_owner
 re_work.permissions = TICKET_MODIFY
 re_work.default = 7

 verify = release -> verify
 verify.operations = set_owner
 verify.permissions = TICKET_MODIFY
 verify.default = 8

 resolve = new,analysis,review,test,in_work,need_info,release, verify -> closed
 resolve.operations = set_resolution
 resolve.permissions = TICKET_MODIFY
 resolve.default = 2

