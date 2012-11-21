#!/usr/local/bin/perl

# from http://www.lemoda.net/perl/strip-diacritics/index.html

use warnings;
use strict;

use CGI qw/-utf8/;
use Unicode::UCD 'charinfo';
use Encode 'decode_utf8';
binmode STDOUT, "utf8";
my $cgi = CGI->new ();

# Print CGI page

print $cgi->header (-charset => 'UTF-8'), $cgi->start_html ();
my $diacritics_text = $cgi->param ('diacritics_text');
$diacritics_text = "" unless $diacritics_text;

my $stripped_text = strip_diacritics ($diacritics_text);
print "<pre>$stripped_text</pre>";
print $cgi->end_html ();
exit 0;

# Remove diacritics from the text.

sub strip_diacritics
{
    my ($diacritics_text) = @_;
    my @characters = split '', $diacritics_text;
    for my $character (@characters) {
        # Reject non-word characters
        next unless $character =~ /\w/;
        my $decomposed = decompose ($character);
        if ($character ne $decomposed) {
            # If the character has been altered, highlight and add a
            # mouseover showing the original character.
            $character =
                "<span title='$character' style='background-color:yellow'>".
                    "$decomposed</span>";
        }
    }
    my $stripped_text = join '', @characters;
    return $stripped_text;
}

# Decompose one character. This is the core part of the program.

sub decompose
{
    my ($character) = @_;
    # Get the Unicode::UCD decomposition.
    my $charinfo = charinfo (ord $character);
    my $decomposition = $charinfo->{decomposition};
    # Give up if there is no decomposition for $character
    return $character unless $decomposition;
    # Get the first character of the decomposition
    my @decomposition_chars = split /\s+/, $decomposition;
    $character = chr hex $decomposition_chars[0];
    # A character may have multiple decompositions, so repeat this
    # process until there are none left.
    return decompose ($character);
}
