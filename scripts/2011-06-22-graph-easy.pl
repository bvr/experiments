
use utf8::all;
use Graph::Easy::Parser::Graphviz;

my $parser = Graph::Easy::Parser::Graphviz->new();

my $dot = <<END_DOT;
digraph {
    rankdir = TB;
    SystemsEng -> "makes/updates\nmodel" -> "run DD" -> "update data\nin DD"
        -> "export\nXML" -> "put it\ninto CM21" -> "put them on\nSIR list";
    "makes/updates\nmodel" -> "matlab" -> "save model" -> "put it\ninto CM21";
}
END_DOT

my $graph = $parser->from_text($dot);
print $graph->as_boxart();
