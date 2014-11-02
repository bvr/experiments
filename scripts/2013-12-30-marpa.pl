#!env perl

# from https://gist.github.com/jddurand/8066327

use strict;
use warnings FATAL => 'all';
use Marpa::R2;
use Data::Section -setup;
use open ':std', ':encoding(utf8)';

our $DATA = __PACKAGE__->local_section_data;

# Grammar and test suite are in __DATA__
# --------------------------------------
my $grammar = Marpa::R2::Scanless::G->new( { source => $DATA->{grammar_source } });
my @tests = grep {"$_"} split(/\n/, ${$DATA->{tests}});

map {printf "%-40s : %s\n", $_, play($grammar, $_)} @tests;

#######################################################

sub play {
    my ($grammar, $input) = @_;

    my $recognizer = Marpa::R2::Scanless::R->new({grammar => $grammar});
    my $length  = length($input);

    my %played = ();
    #
    # 1: Parse
    #
    my $pos = eval {$recognizer->read(\$input)} || do {return $@};
    do {
	#
	# 2: Paused by event on card
	#
	my ($start, $length) = $recognizer->g1_location_to_span($recognizer->current_g1_location());
	my $card = $recognizer->literal($start, $length);
	return "Duplicate card $card." if (++$played{$card} > 1);
	#
	# 3: resume parsing
	#
	eval {$pos = $recognizer->resume()} || do {return (split(/\n/, $@))[0]};

    } while ($pos < $length);

    return $recognizer->value() ? 'OK' : show_last_hand($recognizer);
}

#
# In case parse succeed but is incomplete: get last card parsed
# -------------------------------------------------------------
sub show_last_hand {
  my ($re) = @_;

  my ($start, $end) = $re->last_completed_range('hand');
  return 'No source element was successfully parsed' if (! defined($start));
  my $lastHand = $re->range_to_string($start, $end);
  return "Last hand successfully parsed was: $lastHand";
}
__DATA__
__[ grammar_source ]__
:start ::= deal
deal ::= hands
hands ::= hand | hands ';' hand
hand ::= card card card card card
card ~ face suit
face ~ [2-9jqkaä]:i | '10'
suit ~ [♥♦♣♠]           # Unicode in the grammar
WS ~ [\s]

:lexeme ~ <card>  pause => after event => 'card'
:discard ~ WS

__[ tests ]__
2♥ 5♥ 7♦ 8♣ 9♠
2♥ a♥ 7♦ 8♣ j♥
a♥ a♥ 7♦ 8♣ j♥
a♥ 7♥ 7♦ 8♣ j♥; 10♥ j♥ q♥ k♥ a♥
2♥ 7♥ 2♦ 3♣ 3♦
2♥ 7♥ 2♦ 3♣ A♦
2♥ 7♥ 2♦ 3♣ ä♦
2♥ 7♥ 2♦ 3♣ Ä♦
2♥ 7♥ 2♦ 3♣
2♥ 7♥ 2♦ 3♣ 3♦ 1♦
a♥ 7♥ 7♦ 8♣ j♥; 10♥ j♣ q♥
