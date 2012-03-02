#!/usr/bin/env perl
#
# Finds if a perl file contains 5.10-isms
# but lacks the "use 5.010" at the top
#

use strict;
use warnings;

use Data::Dumper ();
use Getopt::Long ();
use PPI ();

sub ppi_find_use_perl {
    my ($version) = @_;

    # We'll stick the version in a regex (5.010 -> 5\.010)
    $version = quotemeta $version;

    my $ppi_find_sub = sub {
        my $node = $_[1];
        return unless $node->isa('PPI::Statement::Include');
        if ($node->content() =~ m{^use \s+ $version}xo) {
            return 1;
        }
        return 0;
    };

    return $ppi_find_sub;
}

sub has_explicit_version_use {
    my ($ppi_doc, $v) = @_;

    my $find_use = ppi_find_use_perl($v);

    # If the document has a 'use <version>' then we're good
    my $has_use = $ppi_doc->find_any($find_use);

    return $has_use;
}

sub is_510_only_operator {
    my $node = $_[1];

    if (! $node->isa('PPI::Token::Operator')) {
        return 0;
    }

    my $op = $node->content;

    return 1 if
           $op eq '//'
        || $op eq '//='
        || $op eq '~~'
        || $op eq '!~~' ;

    return 0;
}

sub is_510_only_keyword {
    my $node = $_[1];

    if (! $node->isa('PPI::Token::Word')) {
        return 0;
    }

    my $kw = $node->content;

    return $kw eq 'say' ? 1 : 0;
}

sub has_510isms_without_use {
    my ($file) = @_;

    my $ppi_doc = PPI::Document->new($file);

    if (has_explicit_version_use($ppi_doc, '5.010')) {
        return;
    }

    if (my $nodes = $ppi_doc->find(\&is_510_only_operator)) {
        for (@{ $nodes }) {
            warn Data::Dumper::Dumper($_) . "\n";
        }
        return 1;
    }

    if (my $nodes = $ppi_doc->find(\&is_510_only_keyword)) {
        for (@{ $nodes }) {
            warn Data::Dumper::Dumper($_) . "\n";
        }
        return 1;
    }

    return;
}

Getopt::Long::GetOptions(
    'file=s' => \my $file,
);

if (! $file) {
    warn "No file specified. Usage: $0 --file <some-file>\n";
    exit 1;
}
elsif (! -e $file) {
    warn "Can't read file '$file': $!\n";
    exit 2;
}

my $bad_guy = has_510isms_without_use($file);

if ($bad_guy) {
    print "Looks like you forgot a 'use 5.010;'\n";
}
else {
    print "Good boy\n";
}
