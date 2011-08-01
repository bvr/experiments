
use Net::GitHub;
use Data::Dump;

my $github = Net::GitHub->new(owner => 'fayland', repo => 'perl-net-github');
dd $github->repos->show();
