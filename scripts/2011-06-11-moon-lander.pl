
# converted to perl5 from http://strangelyconsistent.org/blog/june-10-2011-a-moon-lander

use 5.010; use strict;
use ActiveState::Prompt qw(prompt);

my $altitude = 70;
my $velocity = 0;
my $fuel     = 7;

my $LANDER = "<|";
my $GROUND = "|";

while(1) {
    my $int_alt = int $altitude;
    my $view = " " x (70 - $int_alt) . $LANDER . " " x $int_alt . $GROUND;

    say $view;
    say "Altitude: $altitude -- Velocity: $velocity -- Fuel: $fuel";

    given(prompt("command> ")) {
        when("thrust") {
            if($fuel > 0) {
                $fuel--;
                $velocity += 3;
            }
            else {
                say "You can't, you're out of fuel!";
            }
        }
        when("wait") {
            # Waiting means doing nothing
        }
        when("quit") {
            say "Good-bye. It was nice trying to land with you.";
            last;
        }
        default {
            say "Available commands:";
            say "";
            say "thrust -- fire the thruster";
            say "wait   -- don't fire the thruster";
            say "quit   -- exit the simulation";
            say "help   -- get this list of commands";

            redo;
        }
    }

    $velocity -= 1.5;
    $altitude += $velocity;

    last if $altitude <= 0;
}

if($velocity >= -3) {
    say " " x 70, $LANDER, $GROUND;
    say "You land softly on the moon.";
}
else {
    say " " x 70, "*#", $GROUND;
    say "You crash fatally into the moon's surface.";
    say "Condolences will be sent to your family.";
}

say "Thanks for playing.";
