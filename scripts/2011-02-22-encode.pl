#!/usr/bin/env perl
use warnings;
use 5.010;
use Encode qw(encode);
my $s = 'a';

for my $encoding ( 'iso-8859-1', 'iso-8859-15', 'cp1252', 'cp850' ) {
    my $encoded = encode( $encoding, $s );
    my $c = unpack '(B8)*', $encoded;
    printf "%-12s:\t%8s\n", $encoding, $c;
}

say "-------------------";

for my $encoding ( 'iso-8859-1', 'iso-8859-15', 'cp1252', 'cp850' ) {
    warn ">>$s<<";
    my $encoded = encode( $encoding, $s, Encode::FB_WARN );
    warn ">>$s<<";
    my $c = unpack '(B8)*', $encoded;
    printf "%-12s:\t%8s\n", $encoding, $c;
}


# iso-8859-1  :   01100001
# iso-8859-15 :   01100001
# cp1252      :   01100001
# cp850       :   01100001
# -------------------
# iso-8859-1  :   01100001
# Use of uninitialized value $c in printf at ./perl1.pl line 20.
# iso-8859-15 :
# Use of uninitialized value $c in printf at ./perl1.pl line 20.
# cp1252      :
# Use of uninitialized value $c in printf at ./perl1.pl line 20.
# cp850       :

