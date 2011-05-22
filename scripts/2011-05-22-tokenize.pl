# from http://www.effectiveperlprogramming.com/blog/183

my @tuples = (
    [ qr/\G\v+/,          'vspace' ],
    [ qr/\G\h+/,          'hspace' ],
    [ qr/\G[[:punct:]]+/, 'punctuation' ],
    [ qr/\G(dog|fox)\b/i, 'animal' ],
    [ qr/\G[a-z]+/i,      'letters' ],
);

my $string = 'The quick brown fox jumped over the lazy dog.';

LOOP:
{
    TUPLE: foreach my $tuple (@tuples) {
        my($pattern, $type) = @$tuple;
        next TUPLE unless $string =~ m/$pattern/pgc;
        push @tokens, [ ${^MATCH}, $type ];
        redo LOOP;
    }
}

foreach my $token (@tokens) {
    printf "%-10s %-10s\n", @$token;
}

