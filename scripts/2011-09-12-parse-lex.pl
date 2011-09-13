use Parse::Lex;

#defines the tokens
@token = qw(
    WS       \s+
    BegParen [(]
    EndParen [)]
    Operator [-+*/^]
    Number   \-?\d+(\.\d*)?
);
$lexer = Parse::Lex->new(@token);    #Specifies the lexer
$lexer->from(\*DATA);                #Specifies the input source

TOKEN: while (1) {
    $token = $lexer->next;
    if (not $lexer->eoi) {
        print $token->name . " " . $token->text . " " . "\n";
    }
    else {
        last TOKEN;
    }
}

__DATA__
43.4*15^2
