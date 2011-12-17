
use Data::Dump qw(pp);

# first attempt
sub mx{$a=shift;$a=$_>$a?$_:$a for@_;$a}
sub mn{$a=shift;$a=$_<$a?$_:$a for@_;$a}

# both at the same time
sub minmax {(sort{$a<=>$b}@_)[0,-1]}

# test

$\="\n";
my @list = (1..10,65,30,2);
print "input: ", pp @list;
print "min: ", mn(@list);
print "max: ", mx(@list);

print "minmax: ", pp minmax(@list);
