package SomeClass;
use Moose;
use MooseX::Declare;

for (sort keys %INC) {
    s{\.pm$}{};
    s{/}{::}g;
    print "$_\n" if /^(Class::MOP|Moose|MooseX)\b/;
}

