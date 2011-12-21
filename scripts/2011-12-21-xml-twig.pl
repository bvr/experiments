
use XML::Twig;

XML::Twig->new(twig_handlers => {
    '/*'        => sub { print $_->gi;           },     # doctypea
    'docnumber' => sub { print $_->trimmed_text; },     # 111
})->parse(\*DATA);


__DATA__
<?xml version="1.0" encoding="utf-8"?>
<doctypea>
  <header someattr="1">
    <docnumber>111</docnumber>
  </header>
</doctypea>
