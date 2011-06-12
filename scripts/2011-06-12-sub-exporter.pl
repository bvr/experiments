
# play with http://advent.rjbs.manxome.org/2009/2009-12-01.html

package main;
use Data::Dump;
use Counter
    -counter => {
        -suffix  => '_receipt',
        callback => sub { print "sending thankyou note for $_[0]\n" },
    },
    -counter => {
        -suffix => '_gift',
    },
;

@presents_we_got  = map { "got_$_"  } 1..5;
@presents_we_gave = map { "gave_$_" } 1..6;

record_receipt($_) for @presents_we_got;
record_gift($_)    for @presents_we_gave;

dd [ list_receipt() ];
dd [ list_gift() ];

dd [ count_gift(), count_receipt() ];

die "life isn't fair" if count_gift > count_receipt;
