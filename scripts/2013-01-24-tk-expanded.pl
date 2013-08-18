use strict;
use Tkx;

my $mw = Tkx::widget->new(".");
$mw->g_wm_title("Hello, world");
$mw->g_wm_minsize(300, 200);

my $b;
$b = $mw->new_button(
    -text => "Hello, world",
    -command => sub {
        $b->m_configure(
            -text => "Goodbye, cruel world",
        );
        Tkx::after(1500, sub { $mw->g_destroy });
    },
);
$b->g_pack(
    -padx => 10,
    -pady => 10,
);

Tkx::tk___messageBox(
   -parent => $mw,
   -icon => "info",
   -title => "Tip of the Day",
   -message => "Please be nice!",
);

Tkx::MainLoop()

