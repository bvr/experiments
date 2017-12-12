
use Test::More;
use Data::Dump;

my @expected = qw(Jan-17	Feb-17	Mar-17	Apr-17	May-17	Jun-17	Jul-17	Aug-17	Sep-17	Oct-17	Nov-17	Dec-17	Jan-18	Feb-18	Mar-18	Apr-18	May-18	Jun-18	Jul-18	Aug-18	Sep-18	Oct-18	Nov-18	Dec-18	Jan-19	Feb-19	Mar-19	Apr-19	May-19	Jun-19	Jul-19	Aug-19	Sep-19	Oct-19	Nov-19	Dec-19);
my @items = build_months(2017 .. 2019);

is_deeply \@items, \@expected, 'match';

done_testing;

=head2 build_months

    my @entries = build_months(2016, 2017);

Build list of months for specified years in format "Month-YY", i.e. Jan-17, Apr-16, etc.

=cut

sub build_months {
    my @years = @_;
    my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
    return map { my $yr = $_; map { $months[$_]."-".substr($yr,2,2) } 0..11 } @years;
}
