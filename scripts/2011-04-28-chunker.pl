
# by Michael Ludwig
# from http://stackoverflow.com/questions/5821072/processing-input-from-while-loop-in-chunks-based-on-information-in-each-string

use strict;
use warnings;

sub make_chunk_proc (&) {
    my( $callback ) = @_;
    my $grouping_key = ''; # start empty
    my @queue;
    return sub {
        if ( @_ ) { # add arguments to current chunk
            my $key = shift;
            return if $grouping_key and $key ne $grouping_key;
            $grouping_key = $key;
            push @queue, [ $key, @_ ];
            return 1;
        }
        else { # commit current chunk and reset state
            $callback->( \@queue );
            $grouping_key = '';
            @queue = ();
        }
    };
}

# ==== main ====

my $chunker = make_chunk_proc {
    my( $queue ) = @_;
    print "@$_\n" for @$queue;
    print '-' x 70, "\n";
};

while ( <DATA> ) {
    chomp;
    my( $key, @rest ) = split /  /;
    $chunker->( $key, @rest ) or do {
        $chunker->();
        $chunker->( $key, @rest );
    }
}
$chunker->(); # commit remaining stuff

__DATA__
2011-04-19  blabla
2011-04-19  blablub
2011-04-20  super
2011-04-20  total super
2011-04-21  weiter
2011-04-22  immer weiter
2011-04-24  immer weiter weiter
