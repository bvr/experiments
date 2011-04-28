
use HTML::TreeBuilder;
use HTML::Tidy;

my $tree = HTML::TreeBuilder->new_from_file("d:/CD/Foto/AGFAnet/cont_picture2.php3.htm");

open my $output,">","out.html" or die;
binmode $output, ":raw:utf8";
print $output HTML::Tidy->new({
    wrap              => 80,
    indent            => 'auto',
    'wrap-attributes' => 'yes',
    newline           => 'LF',
})->clean($tree->as_HTML());
