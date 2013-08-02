
use utf8;
use LWP::Simple qw(get);
use HTML::TreeBuilder;
use Path::Class;
use Try::Tiny;
use Data::Dump;
use List::MoreUtils qw(zip);

my $header = <DATA>;

my @items = qw(url oblast obvod vez cesta clas);
my @paths;
while(<DATA>) {
    chomp;
    my @cols = map { s/^[\s\xC2\xA0]*//; s/[\s\xC2\xA0]*$//; $_ } split /\t/;
    push @paths, { zip @items, @cols };
}
# dd \@paths;

open my $out, '>:utf8', 'summary2.html';
my $page = <<END;
<head>
    <title>Piskari</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <style>
        * { font-family: Verdana; }
        .vypis { font-size: 80%; table-border: solid 1px; padding-top: 20px;  }
        .vypis td, .vypis th { vertical-align: top; }
    </style>
</head>
<body>
END
$page .= page_text($_->{url}) for @paths;
$page .= <<END;
</body>
</html>
END

# final cleanup
$page =~ s/style=".*?"//gs;
$page =~ s/<img .*?>//gs;

print {$out} $page;
exit;



sub page_text {
    my ($url) = @_;

    warn "$url\n";

    my $page_content = get($url);
    unless($page_content) {
        warn "Failed to get\n";
        return '';
    }

    my $html = HTML::TreeBuilder->new_from_content($page_content);
    my @vypis     = $html->look_down(class => "vypis");

    my $html_text = '';
    for (@vypis) {
        $html_text .= $_->as_HTML('<>&',"\t");
    }
    $html->delete;

    sleep(1);
    return $html_text;
}

__DATA__
URL	OBLAST	OBVOD	VEZ	CESTA	CLAS
http://www.piskari.cz/cesta.php?cid=419	Adršpach	 Himálaj 	 Annapúrna 	 Rohová cesta 	 VI
http://www.piskari.cz/cesta.php?cid=2395	Adršpach	 Himálaj 	 Čhogolisa 	 Spára 	 VIIb
http://www.piskari.cz/cesta.php?cid=426	Adršpach	 Himálaj 	 Čhomolhari 	 Pádlovačka 	 VIIa
http://www.piskari.cz/cesta.php?cid=3510	Adršpach	 Himálaj 	 Gangapurna 	 Brahmaputra 	 VIIb
http://www.piskari.cz/cesta.php?cid=2986	Adršpach	 Himálaj 	 Kangčhendžanga 	 Převislá spára 	 VIIb
http://www.piskari.cz/cesta.php?cid=417	Adršpach	 Himálaj 	 Makalu 	 Po galerii 	 VI
http://www.piskari.cz/cesta.php?cid=2473	Adršpach	 Himálaj 	 Manaslu 	 Klempířská 	 VIIa
http://www.piskari.cz/cesta.php?cid=2474	Adršpach	 Himálaj 	 Manaslu 	 Truhlarská 	 VIIb
http://www.piskari.cz/cesta.php?cid=2613	Adršpach	 Jezerka 	 Bubáček 	 Koutem 	 V
http://www.piskari.cz/cesta.php?cid=387	Adršpach	 Jezerka 	 Persefona 	 Ruční spára 	 VIIa
http://www.piskari.cz/cesta.php?cid=574	Adršpach	 Jezerka 	 Pyramida 	 Koutová (Cheopsova var.)	 VIIa
http://www.piskari.cz/cesta.php?cid=1906	Adršpach	 Jezerka 	 Triton 	 Tantalova muka 	 VIIa
http://www.piskari.cz/cesta.php?cid=1857	Adršpach	 Jezerka 	 Vážka 	 Dlouhý šáhlo 	 VIIc
http://www.piskari.cz/cesta.php?cid=1956	Adršpach	 Království 	 Bratranecká 	 Klikatka 	 III
http://www.piskari.cz/cesta.php?cid=2281	Adršpach	 Království 	 Čarodejnice Adr. 	 Praspárka 	 VIIa
http://www.piskari.cz/cesta.php?cid=268	Adršpach	 Království 	 Černokněžník 	 Zelená pro Sama 	 VI
http://www.piskari.cz/cesta.php?cid=113	Adršpach	 Království 	 Hroche 	 Tomáška 	 V
http://www.piskari.cz/cesta.php?cid=273	Adršpach	 Království 	 Járková 	 Vybíhačka 	 V
http://www.piskari.cz/cesta.php?cid=638	Adršpach	 Království 	 Kojná 	 Řeznická spára 	 VIIa
http://www.piskari.cz/cesta.php?cid=451	Adršpach	 Království 	 Mravenčí hora 	 Žlutá spára 	 VIIb
http://www.piskari.cz/cesta.php?cid=2662	Adršpach	 Království 	 Mrdloň 	 Přes škvíru 	 IV
http://www.piskari.cz/cesta.php?cid=446	Adršpach	 Království 	 Orel 	 Náhorní 	 VI
http://www.piskari.cz/cesta.php?cid=1948	Adršpach	 Království 	 Princ 	 Jižní sokolík 	 VIIa
http://www.piskari.cz/cesta.php?cid=637	Adršpach	 Království 	 Princ 	 Kvedlovačka 	 VIIb
http://www.piskari.cz/cesta.php?cid=116	Adršpach	 Království 	 Tři obři 	 Údolní spára 	 VIIb
http://www.piskari.cz/cesta.php?cid=1965	Adršpach	 Království 	 Vztyčená věž 	 Stará cesta 	 III
http://www.piskari.cz/cesta.php?cid=1926	Adršpach	 Království 	 Zámek 	 Beova 	 VIIa
http://www.piskari.cz/cesta.php?cid=120	Adršpach	 Království 	 Zapomenutá 	 Bouřlivá spára 	 VIIa
http://www.piskari.cz/cesta.php?cid=2596	Adršpach	 Město 	 Bedrník 	 Pintráda 	 VI
http://www.piskari.cz/cesta.php?cid=537	Adršpach	 Město 	 Cukrovarský komín 	 Kampaňová cesta 	 VIIa
http://www.piskari.cz/cesta.php?cid=2942	Adršpach	 Město 	 David 	 Dvojspára 	 V
http://www.piskari.cz/cesta.php?cid=542	Adršpach	 Město 	 Fortnýř 	 Sokolík 	 VI
http://www.piskari.cz/cesta.php?cid=2845	Adršpach	 Město 	 Kibic 	 Rychlá spárka 	 III
http://www.piskari.cz/cesta.php?cid=2442	Adršpach	 Město 	 Kurýr 	 Prodloužená záda (Prdel) 	 VI
http://www.piskari.cz/cesta.php?cid=222	Adršpach	 Město 	 Mars 	 Severozápadní spára 	 V
http://www.piskari.cz/cesta.php?cid=421	Adršpach	 Město 	 Permoníček 	 Přirozený třes 	 VIIa
http://www.piskari.cz/cesta.php?cid=2994	Adršpach	 Město 	 Šimon 	 Dlouhý chyt 	 VIIb
http://www.piskari.cz/cesta.php?cid=445	Adršpach	 Město 	 Starostová 	 Stará cesta 	 VIIa
http://www.piskari.cz/cesta.php?cid=1909	Adršpach	 Město 	 Vykřičený dům 	 Kankán 	 VI
http://www.piskari.cz/cesta.php?cid=342	Adršpach	 Milenecká hora 	 Amor 	 Údolní 	 VIIa
http://www.piskari.cz/cesta.php?cid=365	Adršpach	 Milenecká hora 	 Bragliho věž 	 Koutová 	 VI
http://www.piskari.cz/cesta.php?cid=2061	Adršpach	 Milenecká hora 	 Cherubín 	 Čardáš 	 VIIIb
http://www.piskari.cz/cesta.php?cid=349	Adršpach	 Milenecká hora 	 Hrad 	 Polická 	 VIIa
http://www.piskari.cz/cesta.php?cid=2255	Adršpach	 Milenecká hora 	 Křen 	 Koutová(Přímá var ) 	 VIIa
http://www.piskari.cz/cesta.php?cid=367	Adršpach	 Milenecká hora 	 Křídlo 	 Ptačí 	 VIIa
http://www.piskari.cz/cesta.php?cid=2815	Adršpach	 Milenecká hora 	 Lesáček 	 Údolní 	 VIIb
http://www.piskari.cz/cesta.php?cid=2070	Adršpach	 Milenecká hora 	 Rádža 	 Ruční klasička 	 VIIa
http://www.piskari.cz/cesta.php?cid=1862	Adršpach	 Milenecká hora 	 Vosí věž 	 Východní 	 VI
http://www.piskari.cz/cesta.php?cid=438	Adršpach	 Ostrov 	 Rumburak 	 Bačkorkaz 	 VI
http://www.piskari.cz/cesta.php?cid=325	Adršpach	 Ostrov 	 Zrzek 	 Východní 	 V
http://www.piskari.cz/cesta.php?cid=301	Adršpach	 Panoptikum 	 Dafné 	 Severní 	 VIIa
http://www.piskari.cz/cesta.php?cid=2195	Adršpach	 Panoptikum 	 Koberce 	 Stará cesta 	 VIIb
http://www.piskari.cz/cesta.php?cid=4	Adršpach	 Panoptikum 	 Ratejna 	 Hubený ruce 	 VIIa
http://www.piskari.cz/cesta.php?cid=499	Adršpach	 Panoptikum 	 Saská věž 	 Cesta Tomáše Bati 	 VIIa
http://www.piskari.cz/cesta.php?cid=2396	Adršpach	 Panoptikum 	 Žralok 	 Bukanýrská 	 VIIc
http://www.piskari.cz/cesta.php?cid=1875	Adršpach	 Vstupní obvod 	 Bludný holanďan 	 Spára 	 VIIa
http://www.piskari.cz/cesta.php?cid=283	Adršpach	 Vstupní obvod 	 Dědek 	 Východní spára 	 VIIb
http://www.piskari.cz/cesta.php?cid=217	Adršpach	 Vstupní obvod 	 Džbán 	 Janebova 	 VIIa
http://www.piskari.cz/cesta.php?cid=2311	Adršpach	 Vstupní obvod 	 Lehátko 	 Placenta 	 VI
http://www.piskari.cz/cesta.php?cid=427	Adršpach	 Vstupní obvod 	 Mezáč 	 Past na Volhejny 	 VI
http://www.piskari.cz/cesta.php?cid=594	Adršpach	 Vstupní obvod 	 Španělská stěna 	 Študácká dvojspára 	 III
http://www.piskari.cz/cesta.php?cid=2507	Adršpach	 Vstupní obvod 	 Střelmistr 	 Nahatá 	 V
http://www.piskari.cz/cesta.php?cid=322	Adršpach	 Za pískovnou 	 Havran 	 Pomlázková 	 VIIa
http://www.piskari.cz/cesta.php?cid=2556	Adršpach	 Za pískovnou 	 Kovadlina 	 Okukovačka 	 VIIa
http://www.piskari.cz/cesta.php?cid=560	Adršpach	 Za pískovnou 	 Třetí 	 Přes díru 	 VIIa
http://www.piskari.cz/cesta.php?cid=2093	Adršpach	 Za pískovnou 	 Vévoda 	 Vlnková 	 VIIc
http://www.piskari.cz/cesta.php?cid=155	Broumovské stěny	 Hvězda 	 Martinská stěna 	 Hadovka 	 VIIb
http://www.piskari.cz/cesta.php?cid=1892	Broumovské stěny	 Slavenské skály 	 Belzebub 	 Zubatá 	 VIIb
http://www.piskari.cz/cesta.php?cid=1980	Broumovské stěny	 Slavenské skály 	 Krvavý Čepelka 	 Dukátová spára 	 VIIc
http://www.piskari.cz/cesta.php?cid=1870	Křížový vrch	 Jižní věže 	 Hronovské věže 	 Kokšova 	 VIIa
http://www.piskari.cz/cesta.php?cid=2805	Křížový vrch	 Křížový hřeben 	 Opičí 	Pašerácká stezka	 V
http://www.piskari.cz/cesta.php?cid=228	Křížový vrch	 Zdoňovský oblouk 	 Majak	Údolní	 VIIa
http://www.piskari.cz/cesta.php?cid=2130	Křížový vrch	 Zdoňovský oblouk 	 Pižmoň 	 Volání severu 	 VIIc
http://www.piskari.cz/cesta.php?cid=1162	Ostaš	 Dolní labyrint 	 Kocour 	 Mňouk 	 VI
http://www.piskari.cz/cesta.php?cid=1053	Ostaš	 Dolní labyrint 	 Sluj Českých bratří	Červencová	 VIIa
http://www.piskari.cz/cesta.php?cid=1153	Ostaš	 Dolní labyrint 	 Slunečná 	Klikatá spára	 VI
http://www.piskari.cz/cesta.php?cid=1113	Ostaš	 Dolní labyrint 	 Sokol 	 Hrobařova 	 VIIa
http://www.piskari.cz/cesta.php?cid=1136	Ostaš	 Dolní labyrint 	Nekonečná 	Pytlákova varianta	 VIIa
http://www.piskari.cz/cesta.php?cid=1310	Ostaš	 Dolní labyrint 	Popraviště 	Žlutý kout	 VI
http://www.piskari.cz/cesta.php?cid=873	Ostaš	 Horní labyrint 	 Cikánka 	 Náchodská 	 VIIb
http://www.piskari.cz/cesta.php?cid=729	Ostaš	 Horní labyrint 	 Kulisa u Výří brány	 Motýlí	 VIIa
http://www.piskari.cz/cesta.php?cid=3036	Teplice	 Amfiteátr 	 Sluha 	 Vydařená 	 VIIa
http://www.piskari.cz/cesta.php?cid=3512	Teplice	 Bariéra 	 Měsíční 	 Stará cesta 	 VIIa
http://www.piskari.cz/cesta.php?cid=3631	Teplice	 Bašta 	 Romantická 	Cesta zapadajícího slunce	 VI
http://www.piskari.cz/cesta.php?cid=3034	Teplice	 Kamenec 	 Feferonka 	 Pálivá 	 VI
http://www.piskari.cz/cesta.php?cid=154	Teplice	 Kamenec 	 Herinek 	 Oblíbená 	 III
http://www.piskari.cz/cesta.php?cid=1978	Teplice	 Kamenec 	 Kanec	 Direttissima	 VIIa
http://www.piskari.cz/cesta.php?cid=122	Teplice	 Kamenec 	 Krokodýlí stěna 	 Kruhová varianta 	 VIIa
http://www.piskari.cz/cesta.php?cid=2977	Teplice	 Kamenec 	 Stříbrná 	 Žabková 	 VIIa
http://www.piskari.cz/cesta.php?cid=1974	Teplice	 Kamenec 	 Žíznivá 	Saská	 VIIa
http://www.piskari.cz/cesta.php?cid=1872	Teplice	 Skalní a Chrámové nám 	 Hláska 	 Údolní 	 VIIIb
http://www.piskari.cz/cesta.php?cid=2192	Teplice	 Skalní a Chrámové nám 	 Kapucín 	 Sokolík 	 VIIb
