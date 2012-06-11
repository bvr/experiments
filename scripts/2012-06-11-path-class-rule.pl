
use Path::Class;
use Path::Class::Rule;

@ARGV = qw(
    D:\data\perl\experiments\scripts\2010-01-10-xml_defs.pl
    2010-01-10-xml_defs.pl
    ..\*
    2010*.pl
);

my @inc = ('some_path');

my $rule = Path::Class::Rule->new->file;
for my $arg (@ARGV) {
    my $file = file($arg);

    if(-e $file) {
        printf "[%2d] %s\n", $i, $file->absolute;
    }
    else {
        for my $found ($rule->new->file->max_depth(1)->iname($file->basename)->all($file->parent, @inc)) {
            printf "[%2d] %s\n", $i, $found->absolute;
        }
    }
}
continue {
    $i++
}

=head2 NOTES

 - accept simple absolute path
 - accept simple relative path to current directory
 - accept wildcard w/optional path
 - look for files along specified include paths

=cut
