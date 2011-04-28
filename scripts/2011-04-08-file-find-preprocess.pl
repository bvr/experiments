
# http://stackoverflow.com/questions/5599793/findfile-preprocess/5600053#5600053

use strict; use warnings;
use Path::Class;

find({
    wanted     => \&wanted,
    preprocess => \&preprocess,
}, "/home/nelson/invoices/");

sub find {
    my ($param,$dir) = @_;

    die "Existing directory must be specified" unless -d $dir;

    my $last_dir = "";
    dir($dir)->recurse(callback => sub {
        my $file = shift;

        return if $file->is_dir;

        if($param->{preprocess}) {
            my $dir  = $file->parent;
            if($dir ne $last_dir) {
                $param->{preprocess}->($dir);
                $last_dir = $dir;
            }
        }
        if($param->{wanted}) {
            $param->{wanted}->($file);
        }
    });
}

# function definitions

sub wanted {
    my $file = shift;
    print "Calling wanted...\n";
    print "\t$file\n";
}

sub preprocess {
    my $dir = shift;
    print "Calling preprocess...\n";
    print "\t$dir\n";
}
