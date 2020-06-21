
use Path::Class qw(dir file);
use Win32::Shortcut;

for my $file (grep { /\.lnk$/i } dir('.')->children) {
    my $lnk = Win32::Shortcut->new();
    $lnk->Load($file);
    printf "menu%1\$d=%2\$s\ncmd%1\$d=cd %3\$s\n", ++$i, ($file =~ /^(.*)\./)[0], $lnk->{Path};
}
