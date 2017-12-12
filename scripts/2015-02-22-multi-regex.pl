
use 5.16.3;

use Data::Dump;


my $keywords = "FCTOOLS-12, FCTOOLS-64, FCTOOLS-1114";
# my $keywords = "blah blah";

my $jira = join ", ", $keywords =~ /FCTOOLS-(\d+)/g;
dd $jira;
