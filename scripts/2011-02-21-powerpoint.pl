
use Win32::OLE;
use Win32::OLE::Const 'Microsoft PowerPoint';

my $ppt = Win32::OLE->new('PowerPoint.Application')
    or die;
$ppt->{Visible} = 1;

my $pres = $ppt->Presentations->Add;
my $slide1 = $pres->Slides->Add({ Index => 1, Layout => ppLayoutText });
my $slide1 = $pres->Slides->Add({ Index => 2, Layout => ppLayoutText });
