
# first example on Tkx from Tkx::Tutorial
# a simple window with single button, application closes when clicked

use Tkx;

Tkx::button(
    ".b",
    -text    => "Hello, world",
    -command => sub { Tkx::destroy("."); },
);
Tkx::pack(".b");

Tkx::MainLoop()

