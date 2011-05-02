# from http://rjbs.manxome.org/rubric/entry/1885

use strict;

for my $ARG (@ARGV) {
    (my $NEW = $ARG) =~ s/avi$/mkv/;

    my $return = system ffmpeg => (
        '-i',
        $ARG,
        qw(-acodec libfaac -ab 96k -ar 48000 -vcodec libx264 -vpre medium -crf 22 -threads 0),
        $NEW,
    );

    unlink $ARG unless $return;
}

