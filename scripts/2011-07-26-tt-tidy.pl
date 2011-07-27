
use File::Slurp;
my $template = read_file(\*DATA);

# replace TT snippets with <!-- snNN -->
my %snip = ();
my $id   = 0;
$template =~ s/ \[% (.*?) %\] / $snip{++$id} = $1; "<!-- sn$id -->" /gxse;

# run tidy
open my $tidy_fh, '|-', 'tidy -utf8  --preserve-entities y -indent -wrap 120 >tidy_out 2>nul'
    or die;
print $tidy_fh $template;
close $tidy_fh;

# fix code back
my $template_tidied = read_file('tidy_out');
$template_tidied =~ s/<!-- sn(\d+) -->/ "[%$snip{$1}%]" /ge;

# print the result
print $template_tidied;


__DATA__
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1250">
</head>
<body>
    <table>
        <tr><td></td></tr>
        <tr><td>[% aoh.unshift({ label => '', value => 'All types' }); %]</td></tr>
    </table>
</body>
</html>
