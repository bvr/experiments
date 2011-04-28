
my $a = sub { print "I am A\n" };
my $b = sub { print "I am B\n" };

$a->();
$b->();

$c = MagicalCodeRef->enchant($a);

$a->();

print STDERR "$a:That was I just called\n";

BEGIN {
    package MagicalCodeRef;

    use overload '""' => sub {
        require B;

        my $ref = shift;
        my $gv  = B::svref_2object($ref)->GV;
        sprintf "%s:%d", $gv->FILE, $gv->LINE;
    };

    sub enchant { bless $_[1], $_[0] }
}

=head1 DESCRIPTION

and you can create an anonymous coderef that acts normally except when
dereferenced as a string, where it returns the filename and line number of
where it was defined. See the example for usage.

=head1 AUTHORS

    Randal Schwartz (merlyn)
    brian d foy

=cut
