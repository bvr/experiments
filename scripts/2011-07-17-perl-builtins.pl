
use Pod::Find qw(pod_where);

my $perlfunc_path = pod_where({ -inc => 1 }, 'perlfunc');

open my $in, "<", $perlfunc_path or die "$perlfunc_path: $!";
while(<$in>) {
    last if /=head2 Alphabetical/
}

# print functions
while(<$in>) {
    print "$1\n" if /=item (.{2,})/;
}
