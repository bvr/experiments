use File::Find;

my $directory = '.';
find({
    wanted     => sub {},
    preprocess => sub {
        print "$File::Find::dir :\n", join("\n", <*>),"\n\n";
        return @_
    },
}, $directory);
