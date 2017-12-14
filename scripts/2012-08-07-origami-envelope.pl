#!/usr/bin/env perl

# from http://blogs.perl.org/users/polettix/2012/08/origami-envelopes.html

use strict;
use warnings;
use Carp;
use Pod::Usage qw< pod2usage >;
use Getopt::Long qw< :config gnu_getopt >;
use English qw< -no_match_vars >;
my $VERSION = '0.0.1';
use 5.012;
use List::Util qw< max >;

use Log::Log4perl::Tiny qw< :easy >;
Log::Log4perl->easy_init({level => $INFO, layout => '[%d %-5p] %m%n'});

use Image::Magick;

my %config = (scale_threshold => 1024,);
GetOptions(
   \%config,
   qw<
     usage! help! man! version!
     scale_threshold|scale-threshold=i
     >
) or pod2usage(-verbose => 99, -sections => 'USAGE');
pod2usage(message => "$0 $VERSION", -verbose => 99, -sections => ' ')
  if $config{version};
pod2usage(-verbose => 99, -sections => 'USAGE') if $config{usage};
pod2usage(-verbose => 99, -sections => 'USAGE|EXAMPLES|OPTIONS')
  if $config{help};
pod2usage(-verbose => 2) if $config{man};

# Script implementation here
my ($input, $output) = @ARGV;
$output //= "$input.pdf";

INFO "loading $input";
my $image = Image::Magick->new();
$image->Read($input);

my ($width, $height) = $image->Get(qw< width height geometry >);
INFO "original size: $width x $height";

my $scale = get_scale($width, $height);
if (defined $scale) {
   INFO "scaling by $scale%";
   ($width, $height) = map { int($_ * $scale / 100.0) } ($width, $height);
   $image->Scale(width => $width, height => $height);
   ($width, $height) = get_size($image);
   INFO "size after scaling: $width x $height";
}

my ($cropx, $cropy) = get_crop($width, $height);
if (defined $cropx) {
   my $geometry = "${cropx}x$cropy+0+0";
   INFO "cropping by $geometry";
   $image->Crop(gravity => 'Center', geometry => $geometry);
   ($width, $height) = get_size($image);
   INFO "size after crop: $width x $height";
} ## end if (defined $cropx)

my $rotation = $width > $height ? -45 : +45;
INFO "rotating by $rotation degrees";
$image->Rotate(gravity => 'Center', degrees => $rotation);
($image, $width, $height) = blind_clone($image);

my $w = int(0.8367 * $width);
my $geometry_crop = "${w}x$height+0+0";
INFO "cropping with $geometry_crop";
$image->Crop(gravity => 'Center', geometry => $geometry_crop,);
($width, $height) = get_size($image);
INFO "size after crop: $width x $height";

INFO "adding border";
$image->Border(geometry => '22.435%x35.719%', bordercolor => 'White');
($image, $width, $height) = blind_clone($image, page => 'A4');
INFO "size after border: $width x $height";

INFO "saving $output";
$image->Write($output);

sub blind_clone {
   my $original = shift;
   my $clone = Image::Magick->new(@_, magick => 'jpg');
   $clone->BlobToImage($original->ImageToBlob(magick => 'jpg'));
   return ($clone, get_size($clone));
} ## end sub blind_clone_2

sub get_size {
   my ($image) = @_;
   return $image->Get(qw< width height >);
}

sub get_crop {
   my ($x, $y) = @_;
   if ($y > $x) {
      ($y, $x) = get_crop($y, $x);
   }
   else {
      my $ratio = $x / $y;
      if ($ratio > 1.46) {
         $x += int((1.45 - $ratio) * $y);
      }
      elsif ($ratio < 1.44) {
         $y += int((1 / 1.45 - 1 / $ratio) * $x);
      }
      else {
         return;
      }
   } ## end else [ if ($y > $x)
   return ($x, $y);
} ## end sub get_crop

sub get_scale {
   my $value = max @_;
   return int(100 * $config{scale_threshold} / $value);
}

__END__

=head1 NAME

origami-envelope - generate a sheet for creating an origami envelope

=head1 VERSION

Ask the version number to the script itself, calling:

   shell$ origami-envelope --version


=head1 USAGE

   origami-envelope [--usage] [--help] [--man] [--version]

   origami-envelope <input-image> <output-pdf>

=head1 EXAMPLES

   shell$ origami-envelope image.jpg card.pdf


=head1 DESCRIPTION

There is a nice way to make an envelope out of a common printer sheet of
paper, e.g. as described at
L<http://www.origami-instructions.com/easy-origami-envelope.html>. This
program lets you take an image and put in the "clean" side of the
envelope, so that you an personalise it.

Just to give you a couple of examples, you can start from an image file
like L<http://polettix.s3.amazonaws.com/orienv/aquiloni.jgp> and get
a PDF file like L<http://polettix.s3.amazonaws.com/orienv/sample01.pdf>; this
can then be folded according to the instrunctions and... you get your
envelope. Another example can be found at
L<http://polettix.s3.amazonaws.com/orienv/sample02.pdf> (starting from
photo at L<http://polettix.s3.amazonaws.com/orienv/manarola.jpg>).

=head1 OPTIONS

=item --help

print a somewhat more verbose help, showing usage, this description of
the options and some examples from the synopsis.

=item --man

print out the full documentation for the script.

=item --scale-threshold

set the reference size for images. This allows scaling the input
image in order to remove excess details or to have something that
can be handled. Too low a value is likely to jeopardize the program.

=item --usage

print a concise usage line and exit.

=item --version

print the version of the script.

=back


=head1 CONFIGURATION AND ENVIRONMENT

origami-envelope requires no configuration files or environment variables.


=head1 DEPENDENCIES

Image::Magick and Log::Log4perl::Tiny. And a not too old version of perl
as well.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.


=head1 AUTHOR

Flavio Poletti C<polettix@cpan.org>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2012, Flavio Poletti C<polettix@cpan.org>. All rights reserved.

This script is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>
and L<perlgpl>.

Questo script Ã¨ software libero: potete ridistribuirlo e/o
modificarlo negli stessi termini di Perl stesso. Vedete anche
L<perlartistic> e L<perlgpl>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=head1 NEGAZIONE DELLA GARANZIA

PoichÃ© questo software viene dato con una licenza gratuita, non
c'Ã¨ alcuna garanzia associata ad esso, ai fini e per quanto permesso
dalle leggi applicabili. A meno di quanto possa essere specificato
altrove, il proprietario e detentore del copyright fornisce questo
software "cosÃ¬ com'Ã¨" senza garanzia di alcun tipo, sia essa espressa
o implicita, includendo fra l'altro (senza perÃ² limitarsi a questo)
eventuali garanzie implicite di commerciabilitÃ  e adeguatezza per
uno scopo particolare. L'intero rischio riguardo alla qualitÃ  ed
alle prestazioni di questo software rimane a voi. Se il software
dovesse dimostrarsi difettoso, vi assumete tutte le responsabilitÃ
ed i costi per tutti i necessari servizi, riparazioni o correzioni.

In nessun caso, a meno che ciÃ² non sia richiesto dalle leggi vigenti
o sia regolato da un accordo scritto, alcuno dei detentori del diritto
di copyright, o qualunque altra parte che possa modificare, o redistribuire
questo software cosÃ¬ come consentito dalla licenza di cui sopra, potrÃ
essere considerato responsabile nei vostri confronti per danni, ivi
inclusi danni generali, speciali, incidentali o conseguenziali, derivanti
dall'utilizzo o dall'incapacitÃ  di utilizzo di questo software. CiÃ²
include, a puro titolo di esempio e senza limitarsi ad essi, la perdita
di dati, l'alterazione involontaria o indesiderata di dati, le perdite
sostenute da voi o da terze parti o un fallimento del software ad
operare con un qualsivoglia altro software. Tale negazione di garanzia
rimane in essere anche se i dententori del copyright, o qualsiasi altra
parte, Ã¨ stata avvisata della possibilitÃ  di tali danneggiamenti.

Se decidete di utilizzare questo software, lo fate a vostro rischio
e pericolo. Se pensate che i termini di questa negazione di garanzia
non si confacciano alle vostre esigenze, o al vostro modo di
considerare un software, o ancora al modo in cui avete sempre trattato
software di terze parti, non usatelo. Se lo usate, accettate espressamente
questa negazione di garanzia e la piena responsabilitÃ  per qualsiasi
tipo di danno, di qualsiasi natura, possa derivarne.

=cut


