
package Thing;
use Moose;
use MooseX::ClassAttribute;

class_has use_my_var => (is => 'rw');


package SubClass;
use Moose;
extends 'Thing';


package main;

SubClass->use_my_var(1);

print Thing->use_my_var;        # 1
