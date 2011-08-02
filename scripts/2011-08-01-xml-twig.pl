
use strict; use warnings;

use XML::Twig;

my $data = <<END_DATA;
<items>
    <item>
        <data1><data3>   data1 </data3></data1>
        <data2>   data2 </data2>
    </item>
    <item>
        <data1>   data1 </data1>
        <data2>   data2 </data2>
    </item>
</items>
END_DATA


my $t = XML::Twig->new(
    twig_handlers => {
        'item' => sub {
            print
                $_->first_descendant('data3')->trimmed_text, "\t",
                $_->first_child_trimmed_text('data2'),"\n";
        },
    },
)->parse($data);
