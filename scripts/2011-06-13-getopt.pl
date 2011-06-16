
use Getopt::Long;
use Getopt::ArgvFile;
use Data::Dump;

my @n = (1 .. 10);
my %opts = (
    port                  => ':i',
    http_version          => ':s',
    invert_string         => ':s',
    ssl                   => '',
    expect                => ':s',
    string                => ':s',
    post_data             => ':s',
    max_age               => ':i',
    content_type          => ':s',
    regex                 => ':s',
    eregi                 => ':s',
    invert_regex          => '',
    authorization         => ':s',
    useragent             => ':s',
    pagesize              => ':s',
    expected_content_type => ':s',
    verify_xml            => '',
    rc                    => ':i',
    hostheader            => ':s',
    cookie                => ':s',
    encoding              => ':s',
    max_redirects         => ':i',
    onredirect_follow     => ':i',
    yca_cert              => ':s',
);

my %args = ();
GetOptions(\%args,
    'help' => sub { help() },
    map {
        my $i = $_;
        (
            "resource$i:s",
            map { "resource${i}_$_$opts{$_}" } keys %opts
        )
    } @n
) or die;

dd \%args;
