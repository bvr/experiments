
use strict;
use HTML::TreeBuilder;
use File::Slurp;
use List::MoreUtils qw(part);

my $tree = HTML::TreeBuilder->new_from_content(do { local $/; <DATA> });

my %decade = ();

for my $h ( $tree->look_down( class => 'basic' ) ) {

    edit_links( $h );

    my ($year) = ($h->as_text =~ /.*?\((\d+)\).*/);
    my $dec = (int($year/10) + 1)  * 10;

    $decade{$dec} ||= [];
    push @{$decade{$dec}}, $h;
}

for my $dec (sort { $b <=> $a } keys %decade) {
    my $filename = "decades/" . $dec . "-" . ($dec - 9) . ".html";

    my $idx = 0;
    my @items = map { $_->as_HTML('<>&',' ',{}) } @{ $decade{$dec} };
    my $contents = join('',
        '<table>',
        (map { "<tr>@$_</tr>" } part { int($idx++ / 5) } @items),
        '</table>');

    warn($filename, $contents);
}

sub edit_links {
    my $h = shift;

    for my $link ( $h->find_by_tag_name( 'a' ) ) {
        my $href = '../'.$link->attr( 'href' );
        $link->attr( 'href', $href );
    }

    for my $link ( $h->find_by_tag_name( 'img' ) ) {
        my $src = '../'.$link->attr( 'src' );
        $link->attr( 'src', $src );
    }
}


__DATA__
<table>
    <tr>
      <td class="basic" valign="top">
        <a href="details/267226.html" title="" id="thumbimage">
          <img src="images/267226f.jpg"/>
        </a>
        <br/>Cowboys &amp; Aliens &#160;(2011)
</td>
      <td class="basic" valign="top">
        <a href="details/267185.html" title="" id="thumbimage">
          <img src="images/267185f.jpg"/>
        </a>
        <br/>The Hangover Part II &#160;(2011)
</td>
      <td class="basic" valign="top">
        <a href="details/267138.html" title="" id="thumbimage">
          <img src="images/267138f.jpg"/>
        </a>
        <br/>Friends With Benefits &#160;(2011)
</td>
      <td class="basic" valign="top">
        <a href="details/266870.html" title="" id="thumbimage">
          <img src="images/266870f.jpg"/>
        </a>
        <br/>Beauty And The Beast &#160;(1991)
</td>
      <td class="basic" valign="top">
        <a href="details/266846.html" title="" id="thumbimage">
          <img src="images/266846f.jpg"/>
        </a>
        <br/>The Fox And The Hound &#160;(1981)
</td>
    </tr>
</table>
