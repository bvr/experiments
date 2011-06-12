
# from http://advent.rjbs.manxome.org/2009/2009-12-02.html

use 5.010;
use Number::Nary 0.107 -codec_pair => {
    digits => ['ho '],
    postencode => sub {
        (my $s = shift) =~ s/ \z//;
        "Merry Christmas, $s!";
    },
    predecode => sub {
        my $s = lc shift;
        $s =~ s/\Amerry christmas, //;
        $s =~ s/!\z/ /;
        $s;
    },
};

# Appropriate:
say encode(3);

# Not:
say encode(1);

