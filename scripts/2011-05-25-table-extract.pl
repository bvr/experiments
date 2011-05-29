#!perl

use utf8;
use warnings;
use HTML::TableExtract qw(tree);
use LWP::Simple;

$content = get("http://bin.arnastofnun.is/leit.php?q=Fiskisl%C3%B3%C3%B0");

if ($content =~ /orð fundust./){

    $content =~ m/<li><strong><a href="(.*)">/;

    $upphaf = "http://bin.arnastofnun.is/";
    $urlid = $upphaf . $1;
    $content = get($urlid);

    $te  = new HTML::TableExtract(depth=>0, count=>0);

    $te->parse($content);   # this was missing

    $table = $te->first_table_found;
    $table_tree = $table->tree;
    $table_html = $table_tree->as_HTML;

    print $table_html,"\n";
}
