
# from http://stackoverflow.com/questions/8125346/sampling-color-in-an-image-with-perl

use strict;
use warnings;

use GD;

my $img = GD::Image->new('Palisades-woods.jpg');

my ($width, $height) = $img->getBounds;

my $sample_left = $width  / 2 - 10;
my $sample_top  = $height / 2 - 10;
my $sample_width = my $sample_height = 20;

my $n = 0;
my $avg = 0;

for my $y (0 .. $sample_height - 1) {
    for my $x (0 .. $sample_width - 1) {
        my ($r, $g, $b) = $img->rgb( $img->getPixel($x, $y));
        my $rgb =  ($r << 16) + ($g << 8) + $b;
        $avg = ($n * $avg + $rgb) / ($n + 1);
        $n += 1;
    }
}

printf "Average rgb is #%06X\n", $avg;

