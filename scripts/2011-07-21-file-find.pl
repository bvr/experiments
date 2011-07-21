
# 3128 files and 519 directories in d:\DataDict\DDGraph\SMV\trunk\

use File::Find;
use MSDOS::Attrib qw(get_attribs);

my (@dirs,@files);
find({
    wanted => sub {
        my $name = $File::Find::name;
        -d $_ ? push(@dirs,$name) : push(@files,$name);
    },
    preprocess => sub {
        grep { get_attribs($_) !~ /H/ } @_
    },
},
"d:\\DataDict\\DDGraph\\SMV\\trunk");

printf "%d files and %d directories\n",scalar @files, scalar @dirs;
