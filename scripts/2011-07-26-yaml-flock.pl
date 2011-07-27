use strict; use warnings;
use YAML::Syck;
use Fcntl ':flock', 'SEEK_SET';

open my $fh, '+<', 't.yaml';
flock($fh, LOCK_EX) or die "couldn't get lock: $!\n";

my $cfg = YAML::Syck::LoadFile($fh);

$cfg->{a} = 1;
$cfg->{b} = 2;

my $yaml = YAML::Syck::Dump($cfg);
$YAML::Syck::ImplicitUnicode = 1;

seek $fh,0, SEEK_SET;
print $fh $yaml;
close $fh;
