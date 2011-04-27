#!/usr/bin/perl -w

use strict;

package Foo::Bar::NewObject;

use FooBarObject qw( new set get );

warn set();

1;

