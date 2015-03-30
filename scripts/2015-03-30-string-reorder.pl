=head1 Assignment

Today’s exercise is a fun little interview question:

    You are given a string O that specifies the desired ordering of letters in a
    target string T. For example, given string O = “eloh” the target string
    T = “hello” would be re-ordered “elloh” and the target string
    T = “help” would be re-ordered “pelh” (letters not in the order string
    are moved to the beginning of the output in some unspecified order).

Your task is to write a program that produces the requested string re-ordering.

=cut

use 5.16.3;
use Test::More;
use List::MoreUtils qw(part);

is reorder1("hello", "eloh"), "elloh";
is reorder1("help",  "eloh"), "pelh";
is reorder2("hello", "eloh"), "elloh";
is reorder2("help",  "eloh"), "pelh";
is reorder3("hello", "eloh"), "elloh";
is reorder3("help",  "eloh"), "pelh";

sub reorder1 {
    my ($target, $order) = @_;

    my $n = 1;
    my %map = map { $_ => $n++ } split //, $order;
    return join '', map { join '', @{$_//[]} } part { $map{$_} // 0 } split //, $target;
}

sub reorder2 {
    my ($target, $order) = @_;

    my $out = '';
    for my $c (split //, $order) {
        $out .= $c x $target =~ s/$c//g;
    }
    return $target . $out;
}

sub reorder3 {
    my ($target, $order) = @_;

    return join '', sort { index($order,$a) <=> index($order,$b) } split //, $target;
}

done_testing;
