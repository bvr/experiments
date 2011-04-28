use strict;
use Data::Dumper;

my $a = C::Main->new('FTP');
$a->testmethod();

package C::Main;

use strict;

sub new {
    my $class = shift;
    my $type  = shift;
    $class .= "::" . $type;
    my $fmgr = bless {}, $class;
    $fmgr->init(@_);
    return $fmgr;
}

sub init {
    my $fmgr = shift;
    $fmgr;
}

sub testmethod {
    print "SSS";
}

package C::Main::Email;
use strict;
use Net::FTP;

use base qw( C::Main );

sub init {
    my $fmgr = shift;
    my $ftp = $fmgr->{ftp} = Net::FTP->new( $_[0] );
    $fmgr;
}

package C::Main::FTP;
use strict;
use Net::FTP;

use base qw( C::Main );

sub init {
    my $fmgr = shift;
    $fmgr;
}
