#!/usr/bin/env perl

# from http://blogs.perl.org/users/ovid/2012/12/finding-duplicate-code-in-perl.html

use 5.12.0;
use autodie;
use Carp;
use utf8::all;
use File::Spec::Functions qw(catfile catdir);
use File::Find::Rule;
use Getopt::Long;
use Capture::Tiny qw(capture);
use File::Slurp;
use Term::ANSIColor ':constants';

local $Term::ANSIColor::AUTORESET = 1;

GetOptions(
    'window=i'  => \( my $window = 5 ),
    'dir=s'     => \( my $dir    = 'lib' ),
    'ignore=s@' => \my @ignore,
) or die "Bad options";
my $IGNORE = join '|' => @ignore;

my $CACHE_DIR = catdir( $ENV{HOME}, '.find_cnp' );

if ( -d $CACHE_DIR ) {
    my @cached = File::Find::Rule->file->in($CACHE_DIR);
    unlink $_ for @cached;
}
else {
    mkdir $CACHE_DIR;
}

unless ( -d $dir ) {
    croak("Cannot find dir $dir");
}

my @files     = File::Find::Rule->file->name('*.pm')->in($dir);
my $num_files = @files;

for my $i ( 0 .. $#files - 1 ) {
    my $next = $i + 1;
    print WHITE "Processing $next out of $num_files files ";
    for my $j ( $next .. $#files ) {
        print '.';
        my ( $first, $second ) = @files[ $i, $j ];
        search_for_dups( $first, $second, $window );
    }
    print "\n";
}

sub search_for_dups {
    my ( $first, $second, $window ) = @_;

    my $code1 = get_text($first);
    my $code2 = get_text($second);

    my %in_second = map { $_->{key} => 1 } @$code2;

    my $matches_found = 0;
    my $last_found    = 0;
    foreach my $i ( 0 .. $#$code1 ) {
        if ( $in_second{ $code1->[$i]{key} } ) {
            if ( $i == $last_found + 1 ) {
                $matches_found++;
            }
            $last_found = $i;
        }
    }
    if ( $matches_found < $window ) {
        return;
    }

    # brute force is bad!
  LINE: foreach ( my $i = 0; $i < @$code1 - $window; $i++ ) {
        next LINE unless $in_second{ $code1->[$i]{key} };

        my @code1 = @{$code1}[ $i .. $#$code1 ];
        foreach my $j ( 0 .. $#$code2 - $window ) {
            my @code2   = @{$code2}[ $j .. $#$code2 ];
            my $matches = 0;
            my $longest = 0;
          WINDOW: foreach my $k ( 0 .. $#code1 ) {
                if ( $code1[$k]{key} eq $code2[$k]{key} ) {
                    $matches++;
                    my $length1 = length( $code1[$k]{code} );
                    if ( $length1 > $longest ) {
                        $longest = $length1;
                    }
                    my $length2 = length( $code2[$k]{code} );
                    if ( $length1 > $longest ) {
                        $longest = $length1;
                    }
                }
                else {
                    last WINDOW;
                }
            }
            if ( $matches >= $window ) {
                my $line1         = 0 + $code1[0]{line};
                my $line2         = 0 + $code2[0]{line};
                my $code_to_print = '';
                for ( 0 .. $matches - 1 ) {
                    my ( $line1, $line2 ) =
                      map { chomp; $_ } ( $code1[$_]{code}, $code2[$_]{code} );
                    $code_to_print
                      .= $line1 . ( ' ' x ( $longest - length($line1) ) );
                    $code_to_print .= " | $line2\n";
                }
                $i += $window;
                if ( $IGNORE and $code_to_print =~ /$IGNORE/ ) {
                    next LINE;
                }
                say BOLD RED
                  "\nPossible match ($first near line $line1) ($second near line $line2)\n",
                  "Begining at:";
                print WHITE $code_to_print;
            }
        }
    }
}

sub get_text {
    my $file     = shift;
    my $filename = $file;
    $filename =~ s/\W/_/g;
    $filename = catfile( $CACHE_DIR, $filename );
    my @contents;
    if ( -f $filename ) {
        @contents = split /(\n)/ => read_file($filename);
    }
    else {
        ( undef, undef, @contents ) = capture {qx($^X -MO=Deparse,-l $file)};
        write_file( $filename, @contents );
    }
    return add_line_numbers( \@contents );
}

sub add_line_numbers {
    my $contents = prefilter(shift);
    my @contents;

    my $line = 1;
    foreach (@$contents) {
        next if /^\s*\$\^H{/;    # skip those damned strict lines
        if (/^#line\s+([0-9]+)/) {
            $line = $1;
            next;
        }
        push @contents => {
            line => $line,
            key  => munge_line($_),
            code => $_,
        };
        $line++;
    }
    return postfilter( \@contents );
}

sub postfilter {
    my $contents = shift;

    my @contents;
  INDEX: for ( my $i = 0; $i < @$contents; $i++ ) {
        if ( $contents->[$i]{code} =~ /^(\s*)BEGIN\s*{/ ) {    #    BEGIN {
            my $padding =~ $1;
            if ( $contents->[ $i + 1 ]{code} =~ /^$padding}/ ) {
                $DB::single = 1;
                $i++;
                next INDEX;
            }
        }
        push @contents => $contents->[$i];
    }

    #my $lines = join '' => map { $_->{code}} @contents;
    #say BLUE $lines;
    #<STDIN>;

    return \@contents;
}

sub prefilter {
    my $contents = shift;

    my @contents;
    my %skip = (
        sub_begin => 0,
    );
    my $skip = 0;

  LINE: for ( my $i = 0; $i < @$contents; $i++ ) {
        local $_ = $contents->[$i];
        next if /^\s*(?:use|require)\b/;    # use/require
        next if /^\s*$/;                    # blank lines
        next if /^#(?!line\s+[0-9]+)/;  # comments which aren't line directives


        # Modules which import things create code like this:
        #
        #     sub BEGIN {
        #         require strict;
        #         do {
        #             'strict'->import('refs')
        #         };
        #     }
        #
        # $skip{sub_begin} filters this out

        if (/^sub BEGIN {/) {
            $skip{sub_begin} = 1;
            $skip++;
        }
        elsif ( $skip{sub_begin} and /^}/ ) {
            $skip{sub_begin} = 0;
            $skip--;
            next;
        }

        # Modules which use strict often have blocks like this:
        #
        #     BEGIN {
        #         $^H{'indirect'} = q(31664984);
        #         $^H{'feature_unicode'} = q(1);
        #         $^H{'autodie'} = q(Fatal :lexical :all);
        #         $^H{'feature_say'} = q(1);
        #         $^H{'guard Fatal'} = q(ARRAY(0x2300d20));
        #         $^H{'feature_state'} = q(1);
        #         $^H{'autovivification'} = q(52);
        #         $^H{'utf8::all'} = q(1);
        #         $^H{'feature_switch'} = q(1);
        #     }
        #
        # $skip{strict_begin} filters this out
        if (/^(\s*)BEGIN {/) {
            my $padding = $1;
            my $next    = $contents->[ $i + 1 ];
            if ( $next =~ /^\s+\$\^H{/ ) {
                my $index = $i + 2;
              STRICT_SEARCH: while ( $index++ ) {
                    next if $contents->[$index] =~ /^\s+\$\^H{/;   # $^H{'...'}
                    last STRICT_SEARCH
                      if not /^$padding}/
                    ;    # the block did not terminate as we expect
                    $i = $index;
                    next LINE;
                }
            }
        }

        push @contents => $_ unless $skip;
    }
    return \@contents;
}

sub munge_line {
    local $_ = shift;
    chomp;
    s/\s//g;
    return $_;
}

__END__

=head1 NAME

find_duplicate_code

=head1 SYNOPSIS

 find_duplicate_code --window 7 --dir lib/ --ignore 'catch {'

=head1 DESCRIPTION

This program searches for cut-n-paste code. It does not (at the present time)
try to account for cases where people may have changed variable names, but it
applies a heuristic process for finding duplicate code and works moderately
well. It's also slow.

For every file in the target directory, C<--dir> (defaults to C<lib/>), it
runs the code through L<B::Deparse>, caches it, and then walks through that
code comparing C<--window> number of lines (default 5). If that many lines
matches, as determined by stripping all whitespace and doing an C<eq>, then we
have duplicated code.

Blank lines are skipped, as are C<use> and C<require>. This may be
configurable in the future.

=head1 OPTIONS

 --window,-w   Minimum number of lines to needed for a match (default 5)
 --dir,-d      Directory of .pm files to search through (default 'lib/')
 --ignore,-i   Duplicates to ignore (may be repeated).

The C<--ignore> switch may be useful if you are repeatedly getting "duplicate"
sections of code that you aren't interested in refactoring right now. The
values of C<--ignore> are joined with a pipe and the check looks like this:

    if ( $ignore and $duplicate_code =~ /$ignore/ ) {
        # don't report this chunk of code as a duplicate
    }
