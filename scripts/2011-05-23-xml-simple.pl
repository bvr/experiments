
use XML::Simple;
use Data::Dump;

my $data = XMLin(<<END, ForceArray => 1, KeepRoot => 1);
<?xml version="1.0"?>
<Request>
  <Version>1.0.0</Version>
  <App>ConstDict</App>
  <EID>E374642</EID>
  <Model>PF_RY_WHATEVER</Model>
</Request>
END

dd $data;

print XMLout($data, KeepRoot => 1);
