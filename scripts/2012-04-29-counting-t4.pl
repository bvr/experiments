#!/usr/bin/perl

# from http://blogs.perl.org/users/salvador_fandino/2012/03/solving-carl-masaks-counting-t4-configurations-problem-in-pure-perl-5.html

use strict;
use warnings;

my $tab = <<EOT;
-----xxx
------xx
x-----xx
x------x
xx-----x
xx------
xxx-----
EOT

my $vertical = index $tab, "\n";
my $diagonal = $vertical + 1;

my $acu = { $tab => 1 };

for my $ix (0 .. length($tab) - 1) {
    my %next;
    while (my ($k, $c) = each %$acu) {
        my $s = substr($k, 0, 1, '');
        $next{$k} += $c;
        if ($s eq '-') {
            my $k1 = $k;
            if ($k1 =~ s/^-/x/) { # horizontal xx
                $next{$k1} += $c;
                if ($k1 =~ s/^x-/xx/) { # horizontal xxx
                    $next{$k1} += $c;
                }
            }
            $k1 = $k;
            if ($k1 =~ s/^(.{$vertical})-/${1}x/os) { # vertical xx
                $next{$k1} += $c;
                if ($k1 =~ s/^(.{$vertical}x.{$vertical})-/${1}x/os) {  # vertical xxx
                    $next{$k1} += $c;
                }
            }
            $k1 = $k;
            if ($k1 =~  s/^(.{$diagonal})-/${1}x/os) { # diagonal xx
                $next{$k1} += $c;
                if ($k1 =~ s/^(.{$diagonal}x.{$diagonal})-/${1}x/os) {  # diagonal xxx
                    $next{$k1} += $c;
                }
            }
        }
    }
   $acu = \%next;
}

my ($k, $c) = each %$acu;
print "total: $c\n";
