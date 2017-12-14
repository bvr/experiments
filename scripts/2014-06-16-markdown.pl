
use 5.10.1; use strict; use warnings;
use Text::Markdown 'markdown';

my $text = 'This is a link [minutes](http://web.az76.honeywell.com/WebApps/MAIDS/Meeting/MtgMinutes.asp?State=View&MtgID=433)';
say markdown($text);
