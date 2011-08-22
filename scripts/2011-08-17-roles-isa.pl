
# from https://gist.github.com/628748

package Role;
use Moose::Role;

package Base;
use Moose;

package Subclass;
use Moose;
extends 'Base';

package main;
use feature 'say';

say Subclass->new->isa('Base')?'yes':'no'; # yes

say Role->meta->apply(Subclass->new)->isa('Base')?'yes':'no'; # yes

my $bc_obj = Base->new;
Role->meta->apply($bc_obj);
say Subclass->new->isa(ref $bc_obj)?'yes':'no'; # no
