
use strict; use warnings; use utf8;

my $file = "d:\\document.txt";
open my $in,'<:raw',$file or die "$file: $!";
my $data = do { local $/; <$in> };

my %mappings = (
    "\xC3\x83\xC2\xA1" => 'á',
    "\xC3\x83\xC2\xAD" => 'í',
    "\xC3\x83\xC2\xA9" => 'é',
    "\xC3\x83\xC2\xBD" => 'ý',
    "\xC3\x84\xC2\x8D" => 'č',
    "\xC3\x85\xCB\x86" => 'ň',
    "\xC3\x85\xC2\xBE" => 'ž',
    "\xC3\x85\xC2\xAF" => 'ů',
    "\xC3\x85\xC2\xA0" => 'Š',
    "\xC3\x83\xC2\xBA" => 'ú',
    "\xC3\x85\xC2\xA1" => 'š',
    "\xC3\x85\xE2\x84\xA2" => 'ř',
    "\xC3\x84\xE2\x80\xBA" => 'ě',
    "\xC3\x83\xC5\xA1" => 'Ú',
    "\xC3\x84\xC2\x8F" => 'ď',
    "\xC3\x85\xC2\xA5" => 'ť',
    "\xC3\x83\xC2\xB6" => 'ö',
    "\xC3\x83\xC2\xB3" => 'ó',
    "\xC3\x84\xC5\x92" => 'Č',
    "\xC3\x85\xCB\x9C" => 'Ř',
    "\xC3\x82\xC2\xB0" => '°',
    "\xC3\x83\xE2\x80" => 'É',
    "\xC3\x85\xC2\xBD" => 'Ž',
    "\xC3\x83\xC2\xB4" => 'ô',
    "\xC3\x82\xC2\xB4" => '\'',
);

my $re = '(' . join('|', keys %mappings) . ')';
$data =~ s{$re}{ $mappings{"$1"} }ge;

use Data::Dump;

my %not_found;
$data =~ s{(.{10})(\xC3.{3})(.{10})}{
    $not_found{ join '', map { sprintf "\\x%02X", ord } split(//,$2) } = "$1\[\]$3";
    "$1$2$3"
}ge;

dd \%not_found;


binmode STDOUT, 'utf8';
print $data;
