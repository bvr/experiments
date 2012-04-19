
# from http://blog.nu42.com/2012/04/htmltableextract-is-beautiful.html

use strict; use warnings;
use HTML::TableExtract;

my $te = HTML::TableExtract->new(
    attribs => { id => 'tbl' },
);

# local copy of
# http://bea.gov/iTable/iTableHtml.cfm?reqid=9&step=3&isuri=1&903=58

$te->parse_file('personal-income.html');

my ($table) = $te->tables;

for my $row ($table->rows) {
    my ($undef, $label, @row) = @$row;
    next unless defined $label;
    if ($label eq 'Unemployment insurance') {
        print "$label\t@row\n";
    }
}
