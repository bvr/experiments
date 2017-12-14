use 5.010; use strict; use warnings;
use URI;
use Data::Dump;
use List::MoreUtils qw(zip);
use Text::xSV;

my $sel_trac = '787Tools';
my $uri = URI->new("http://fctools-scm/trac/$sel_trac/newticket");

# first row in the DATA section is list of columns
my $csv = Text::xSV->new(fh => \*DATA, sep => "\t");
$csv->read_header;
my @cols  = $csv->get_fields;

# for each subsequent row, generate URL
while($csv->get_row()) {
    my %data = $csv->extract_hash(@cols);

    $uri->query_form(%data);
    say $uri->as_string;
}

__DATA__
summary	owner	description	type	status	priority	milestone	component	version	resolution	keywords	cc	blockedby	blocking	estimatedhours	totalhours
OVOC RRMT usage in Development and V&V	PrasadKeshavaR	"==OVOC for RRMT usage during CR development and V&V== OVOC in progress - Talking to the CR & TR Owners on how RRMT is used.

"	enhancement	in_work	major	RRMT 5.0.0 Phase 3	Trace VPD							20	0
Bleh
Blam
Fluf
