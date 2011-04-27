
use Path::Class;

my @files;
dir('.')->recurse(callback => sub {
    my $file = shift;
    if($file =~ /some text/) {
        push @files, $file->absolute->stringify;
    }
});

for my $file (@files) {
    # ...
}
