
use XML::Twig;

XML::Twig->new()->parse(*DATA);

__DATA__
<table name="content_analyzer" primary-key="id">
  <type="global" />
</table>
<table name="content_analyzer2" primary-key="id">
  <type="global" />
</table>
<table name="content_analyzer_items" primary-key="id">
  <type="global" />
</table>
