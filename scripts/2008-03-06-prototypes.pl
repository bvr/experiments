
# forward define prototypes

sub f1($$);
sub f2(\@$);
sub f3(&@);
sub zip(&\@\@);
sub zipr(\@\@&);
sub anything(\[$@%]);

# some testing values

my $a = 10;
my $b = 20;
my @c = (1,2,3);
my @d = (7,6,3,8);

# call it

f1 @c,$a;
f2 @c,$a;
f3 { ($a,$b) = splice(@_,0,2); "$b: ".($a + 10) } @c;
%h = zip { $a+1,$b } @c, @d;

zipr @c, @d, sub { 
    print "$a .. $b\n" 
};

use Dumpvalue;
my $dumper = new Dumpvalue(hashDepth => 10, arrayDepth => 10, unctrl => 1);
$dumper->dumpValue(\%h);

anything(@c);
anything(%h);
anything($a);


# function definitions

sub f1($$) {
    print "f1: @_\n";
}

sub f2(\@$) {
    print "f2: @_\n";
}

sub f3(&@) {
    my ($code,@arr) = @_;
    print "f3: @_\n";
    my $i = 0;
    for (@arr) {
        print " - ",&$code($_,++$i),"\n";
    }
}

sub zip(&\@\@) {
    my ($code,$a1,$a2) = @_;
    my $l = $#$a1>$#$a2 ? $#$a1 : $#$a2;
    my @result = ();
    for my $i (0..$l) {
        $a = $a1->[$i];
        $b = $a2->[$i];
        push @result,&$code();
    }
    return @result;
}

sub zipr(\@\@&) {
    my ($a1,$a2,$code) = @_;
    print "zipr @_\n";
    zip \&$code,@$a1,@$a2;
}

sub anything(\[$@%]) {
    my ($got) = @_;
    print "anything: $got\t",ref($got),"\n";
}
