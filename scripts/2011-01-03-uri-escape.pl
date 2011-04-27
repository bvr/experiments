
use 5.010; use strict; use warnings;
use URI::Escape qw(uri_escape);
use CGI         qw(escapeHTML);

say uri_escape("6465456#");
