
use Test::More;

use Template;

my $format_number = <<'TEMPLATE';
[%~ BLOCK format_type ~%]
  [%~ FOREACH index IN [ 0..values4format.max ] ~%]
    [%~ SWITCH type ~%]
    [%~ CASE [ 'real_T' ] ~%]
      [%~ UNLESS (values4format.$index.match('\.')) ~%]
        [%~ values4format.$index = values4format.$index _ "." ~%]
      [%~ ELSE ~%]
        [%~ values4format.$index = values4format.$index ~%][%# .replace('([^0])0+$', ('$1')) %]
      [%~ END ~%]
      [%~ IF (values4format.$index.match('\.$')) ~%]
        [%~ values4format.$index = values4format.$index _ "0" ~%]
      [%~ END ~%]
      [%~ UNLESS (values4format.$index.match('f$')) ~%]
        [%~ values4format.$index = values4format.$index _ "f" ~%]
      [%~ END ~%]
    [%~ CASE [ 'boolean_T' ] ~%]
      [%~ IF values4format.$index > 0 ~%]
        [%~ values4format.$index = "TRUE" ~%]
      [%~ ELSE ~%]
        [%~ values4format.$index = "FALSE" ~%]
      [%~ END ~%]
    [%~ END ~%]
  [%~ END ~%]
[%~ END -%]
[% PROCESS format_type type = 'real_T', values4format = [ items ] ~%]
[% values4format.0 ~%]
TEMPLATE

my $tt2 = Template->new;

my $num_re = qr/^ ( [-]? [0-9]* (\.[0-9]+)? ([eE][+-]?[0-9]+)? ) $/x;

my @match = (
    '',
    '.2',
    '0',
    '-0',
    '-2',
    '20',
    '-5.1',
    '6.045',
    '-9.2e1',
    '10e-5',
    '5E+200',
);

ok(/$num_re/,  "\"$_\" matches") for @match;

warn "\n";

for my $num (@match) {
    my $output;
    $tt2->process(\$format_number, { items => $num }, \$output) or die $tt2->error();
    warn sprintf "printed %-10s => \"%s\"\n", "\"$num\"", $output;
}

done_testing;
