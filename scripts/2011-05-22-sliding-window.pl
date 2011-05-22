#!/usr/bin/perl -w
#
# from http://perlmonks.org/index.pl?node_id=128925
#
# Proof-of-concept for using minimal memory to search huge
# files, using a sliding window, matching within the window,
# and using on /gc and pos() to restart the search at the
# correct spot whenever we slide the window.
#
# Doesn't correctly handle potential matches that overlap;
# the first fragment that matches wins.
#

use strict;
use constant BLOCKSIZE => (8 * 1024);

search("bighuge.log",
    sub { print $_[0], "\n" },
    "<img[^>]*>"
);

sub search {
    my ($file, $callback, @fragments) = @_;

    open(my $in, "<", $file) or die "$file: $!";
    binmode($in);

    # prime the window with two blocks (if possible)
    my $nbytes = read($in, my $window, 2 * BLOCKSIZE);

    my $re = "(" . join("|", @fragments) . ")";

    while($nbytes > 0) {

        # match as many times as we can within the
        # window, remembering the position of the
        # final match (if any).
        while($window =~ m/$re/oigcs) {
            $callback->($1);
        }
        my $pos = pos($window);

        # grab the next block
        $nbytes = read($in, my $block, BLOCKSIZE);
        last if $nbytes == 0;

        # slide the window by discarding the initial
        # block and appending the next. then reset
        # the starting position for matching.
        substr($window, 0, BLOCKSIZE) = '';
        $window .= $block;
        $pos -= BLOCKSIZE;
        pos($window) = $pos > 0 ? $pos : 0;
    }
}

