
use Template;

my $tt = Template->new();

$tt->process( \*DATA,
    {   ip    => '10.90.0.1',
        host  => 'some',
        alias => 'some_alias',
    } => 'file.cfg'
) or die $tt->error();


__DATA__
define hosts {
       host_name      [% host %]
       alias          [% alias %]
       address        [% ip %]
       }

