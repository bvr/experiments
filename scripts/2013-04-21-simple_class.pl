
BEGIN {
        package class;
        use Moose;

        has name    => (is => 'ro');
        has roll_no => (is => 'ro');
        has sub1    => (is => 'ro');
        has sub2    => (is => 'ro');
        has sub3    => (is => 'ro');
        has sub4    => (is => 'ro');
        has sub5    => (is => 'ro');
        has sub6    => (is => 'ro');
}

# use class;

print "Object 1:\n\n";

my $obj1 = class->new(
    name    => "sam",
    roll_no => "1",
    sub1    => "99",
    sub2    => "98",
    sub3    => "97",
    sub4    => "96",
    sub5    => "95",
    sub6    => "96"
);


print $obj1->name,    "\n";
print $obj1->roll_no, "\n";
print $obj1->sub1,    "\n";
print $obj1->sub2,    "\n";
print $obj1->sub3,    "\n";
print $obj1->sub4,    "\n";
print $obj1->sub5,    "\n";
print $obj1->sub6,    "\n";
