use HTML::TreeBuilder;

my $parser = HTML::TreeBuilder->new();
my %opts = (
    no_expand_entities          => 1,
    ignore_ignorable_whitespace => 0,
    no_space_compacting         => 1,
    store_comments              => 1,
);
$parser->$_($opts{$_}) for keys %opts;

my $tree = $parser->parse_file("delicious.html");

for my $bookmark ($tree->find("a")) {
    my @tags = map { lc } grep { !/^shortcut/ } split /[\s,]+/, $bookmark->attr("TAGS");
    $bookmark->attr("TAGS" => undef);
    my $new_text = $bookmark->as_text() . " " . join(" ", map { "[$_]" } @tags);
    # warn $new_text, "\n";
    $bookmark->detach_content();
    $bookmark->push_content($new_text);
}

open my $out,">","delicious-conv.html" or die;
print $out $tree->as_HTML('<>',"\t");
close $out;

