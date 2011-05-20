use Win32::Unicode::Native;
use ojo;        # Mojo one-liners
use Text::Autoformat;

say autoformat(g("http://pocasi.divoch.cz/svet.php?icao=LKTB")->dom->at('.metar-zprava')->all_text);

