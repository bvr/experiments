
use 5.10.1;
use Devel::Peek;

my $input = 'begin one end -- begin two end';

my @sections = $input =~ /begin(.*?)end/g;

for $sec (@sections) {
    say $sec =~ /one/ ? 'match' : 'not match';
    say $sec =~ /two/ ? 'match' : 'not match';
    Dump($sec);
}
