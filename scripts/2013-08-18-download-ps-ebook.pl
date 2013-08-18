
use 5.16.0;
use Mojo::UserAgent;
use Mojo::URL;
use Path::Class;
use Data::Dump qw(dd pp);

my $url = Mojo::URL->new('http://powershell.com/cs/blogs/ebookv2/default.aspx');
my $ua  = Mojo::UserAgent->new(max_redirects => 5);

my @pages = ();
for my $heading ($ua->get($url)->res->dom('ul.CommonAvatarListItemList li h4')->each) {
    push @pages, {
        url  => Mojo::URL->new($url)->path($heading->at('a')->{href}),
        text => $heading->all_text,
    };
}

binmode(STDOUT, ':raw');
open my $out, ">:utf8", "index.html" or die;
print {$out} <<END;
<html>
<head>
<title>Mastering Powershell</title>
<style>
    .keystroke, .pscode, .psoutput { font-family: monospace }
</style>
<body>
END
for my $item (@pages) {
    warn $item->{text} . "\n\t" . $item->{url}->to_string . "\n";

    print {$out} "<h1>$item->{text}</h1>\n";

    my $chapter = $ua->get($item->{url})->res->dom->at('#CommonContentInner .CommonContentBoxContent');

    # handle images
    $chapter->find('img')->each(sub {
        my ($img) = @_;

        # determine image URL and filename
        my $img_url = Mojo::URL->new($img->attr('src'))->to_abs($item->{url});
        my $filename = $img_url->path->parts->[-1];
        warn "\t - " . $img_url . " -> " . $filename . "\n";

        # get file and replace attribute with downloaded one
        $img->attr(src => $filename);
        file($filename)->spew(iomode => '>:raw', $ua->get($img_url)->res->body);
    });

    # handle the chapter
    print {$out} $chapter->to_xml;
}


=head1 TODO

Download all pages from above link, then make a single HTML page out of it

=cut
