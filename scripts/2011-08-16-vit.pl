use strict;
use warnings;
use re 'debug';


my $str = '/*/ asdf ///**/*/';
if ($str =~ m{/\*(([^\*/]+/*)|(\*+))*\*/}) {
    print "je tam:\n" . $& . "\n";
}
else {
    print "neni";
}

