use 5.010;
use Regexp::Grammars;
my $parser = qr{
        (?:
            <[Name]>{2}
        )
        <rule: Name>
            ((?:fir|la)st name: \w+)
}x;

while (<DATA>) {
    /$parser/;
    use Data::Dumper; say Dumper $/{Name};
}

__DATA__
character first name: Han last name: Solo
character last name: Solo first name: Han

