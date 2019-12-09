
use 5.10.1; use strict; use warnings;
use Path::Class;
use Path::Class::Rule;
use Params::Validate qw(validate validate_pos ARRAYREF CODEREF SCALAR);
use Getopt::Long;
use List::Util 'reduce';

=head1 DESCRIPTION

See L</run> function for operation description. Run the script with B<--help>
option to see usage instructions.

=cut

my $default_photo_dir = '00-Incoming';
GetOptions(
    'help'   => sub { help() },
    'dir:s'  => \(my $dir    = $default_photo_dir),
    'dryrun' => \(my $dryrun = 0),
    'last:i' => \(my $last),
    'test'   => \&run_tests,
) or help("Commandline parsing failed");

# prepare inputs - dir/series
my $photo_dir = dir($dir);
my $last_file = $photo_dir->file('last');
$last ||= $last_file->slurp;
$last = sprintf "%03d", $last;

my $final_series = run($photo_dir, $last);

# store the series back
$last_file->spew($final_series);
exit;

=head2 run

    use Path::Class 'dir';
    run(dir("C:\\Photos"), $last_series);

The main operation of the script. Does the following:

=over

=item *

Renames "YYYY-MM-DD" directories in specified directory to "YYMMDD -"

=item *

All DSC* files outside the directories above put into such based on
EXIF date stored in them.

=item *

Locate all DSC* files in the directory and rename them to SSS-NNNN.*, where SSS
is current series and NNNN original file number. The initial series number
is second parameter. If the number of files obviously run over 9999, the series is
incremented.

=item *

Returns the final series.

=back

=cut

sub run {
    my ($photo_dir) = validate_pos(@_,
        { isa   => 'Path::Class::Dir'},
        { regex => qr/^\d{3}$/ },
    );

    # rename directories
    photo_dir_do(
        items  => [ $photo_dir->children ],
        action => sub {
            my ($old, $new) = @_;
            do_rename($old => $new);
        },
    );

    # locate all image files outside directories
    move_files_into_date_dirs(
        photo_dir => $photo_dir,
        files => [ grep { -f } $photo_dir->children ]
    );

    # locate all files and group them into buckets by thousand number: DSC_(X)NNN.*
    my @all_files = Path::Class::Rule->new->file->all($photo_dir);
    my %buckets = bucketize_files(@all_files);

    # split buckets to those with current series and next series (optional)
    my ($cur_prefix, $inc_prefix) = bucketize(keys %buckets);

    # rename files with current prefix
    rename_files(prefix => $last, files => [map { @$_ } @buckets{@$cur_prefix}]);
    return $last unless $inc_prefix;

    # rename files with incremented prefix
    $last = sprintf "%03d", $last+1;
    rename_files(prefix => $last, files => [map { @$_ } @buckets{@$inc_prefix}]);
    return $last;
}

=head2 rename_files

    rename_files(
        prefix => '013',
        files  => [ file('DSC_0001.JPG'), file('DSC_0002.JPG') ]
    );

Takes two named parameters. Renames files with pattern like DSC_XXXX.JPG into
prefix-XXXX.JPG using L<do_rename> function.

=cut

sub rename_files {
    my %p = validate(@_, {
        prefix => { type => SCALAR },
        files  => { type => ARRAYREF },
    });
    my $prefix = $p{prefix};
    my @files  = @{$p{files}};

    for my $file (@files) {
        my $new_name = $file->basename;
        $new_name =~ s/DSC_(.*)/$prefix-$1/;
        my $new_file = $file->parent->file($new_name);
        do_rename($file, $new_file);
    }
}

=head2 photo_dir_do

    photo_dir_do(
        items  => [ $photo_dir->children ],
        action => sub {
            my ($old, $new) = @_;
            do_rename($old => $new);
        },
    );

Takes two named parameters. List of L<Path::Class> items and a callback
to perform an action. It is called on all photo directories (named "YYYY-MM-DD")
and new name is offered as second parameter to the callback.

=cut

sub photo_dir_do {
    my %p = validate(@_, {
        action => { type => CODEREF },
        items  => { type => ARRAYREF },
    });
    my $action = $p{action};

    # find all directories named "YYYY-MM-DD" and rename it to "YYMMDD -"
    for my $dir (@{$p{items}}) {
        if($dir->is_dir && $dir =~ /^\d{2}(\d{2})-(\d{2})-(\d{2})$/) {
            $action->($dir, "$1$2$3 -");
        }
    }
}

=head2 move_files_into_date_dirs

    move_files_into_date_dirs(files => [ file('aa.jpg'), file('bb.jpg') ]);

Take list of image files, extract EXIF created date and move the files into
directories named YYMMDD.

=cut

sub move_files_into_date_dirs {
    my %p = validate(@_, {
        files  => { type => ARRAYREF },
        photo_dir => { isa   => 'Path::Class::Dir' },
    });
    my $photo_dir = $p{photo_dir};

    for my $file (@{ $p{files} }) {
        my $block = `jhead -exonly "$file" 2>nul`;
        my %items = $block =~ /^ ([^:]+?) \s* : \s* (.*?) \s*$ /gmx;
        if(defined $items{"File date"} && $items{"File date"} =~ /^\d{2}(\d{2}):(\d{2}):(\d{2})/) {
            my $dir = $photo_dir->subdir("$1$2$3");
            unless(-d $dir) {
                $dir->mkpath;
            }
            do_rename($file, $dir->file($file->basename));
        }
        else {
            warn "Warning: \"$file\" has been not been moved, no EXIF date\n";
        }
    }

}

=head2 bucketize_files

    my %bf = bucketize_files(@files);

Group files with DSC naming by thousand order. Files are supposed to be
L<Path::Class::File>, resulting hash is keyed by the single number:

    %bf = ( '0' => [ files ], '1' => [ files ], .... )

=cut

sub bucketize_files {
    my %buckets;
    for my $file (@_) {
        if($file->basename =~ /^DSC[_F](\d)/i) {
            $buckets{$1} ||= [];
            push @{$buckets{$1}}, $file;
        }
    }
    return %buckets;
}

=head2 bucketize

    my ($curr_series, $next_series) = bucketize('0', '1', '9');

This function get list of thousand orders and calculate which belong
to current series and which will be next one. Returns two arrayrefs.

For example, the call above returns

    ['9'], ['0', '1']

indicating overflow over 9999. This helps to perform file renaming step
described in L</run> function.

=cut

sub bucketize {
    my @seq = sort @_;

    # empty input
    return [] unless @seq;

    # arrange items into list of sequences
    my $out = [[ shift @seq ]];
    reduce {
        $a->[-1][-1] + 1 == $b
            ? push @{$a->[-1]}, $b
            : push @$a, [$b];
        $a
    } $out, @seq;

    # return one or two arrayrefs (last sequence first, rest merged to second)
    my $last_item = pop @$out;
    my @rest = map { @$_ } @$out;
    return $last_item, @rest ? \@rest : ();
}

=head2 do_rename

    do_rename($file, $new_name);

Reports renaming and perform the action, unless C<$dryrun> global is set.

=cut

sub do_rename {
    my ($old, $new) = @_;

    warn "rename \"$old\" -> \"$new\"\n";
    rename($old, $new) unless $dryrun;
}

=head2 help

    help();
    help("There was en error");

Prints usage and exit. Optionally prints error message if supplied.

=cut

sub help {
    print STDERR "Error: @_\n\n" if @_;

    my $script_name = file($0)->basename;
    print STDERR <<USAGE;
Usage: $script_name [options]

Processing of photo download directories. Does number of operations:

 - Renames "YYYY-MM-DD" directories (created by MS Photo Downloader) to
   "YYMMDD -" names I am using in my collection.

 - Image files directly in photo directory moves into directories named "YYMMDD"
   according to information stored in EXIF of the photos.

 - Finds all DSC files recursively and rename them to SSS-NNNN.* format,
   where SSS is the series and NNNN is original number of the file. Series is
   automatically increased when overflow over 9999 is detected.

Options:
  --dir       Specify directory with photos. Default to "$default_photo_dir"
  --dryrun    Do not perform any real action
  --last      Specify last photo series. Default taken from "last" file in photo directory
  --help      Print this instructions

Examples:

  $script_name
  $script_name --dryrun
  $script_name --dir C:\\Photos --dryrun
  $script_name --dir C:\\Photos --last 17

USAGE
    exit;
}

=head2 run_tests

Internal. Perform unit tests on the script. Called if B<--test> option is
specified on command-line.

=cut

sub run_tests {
    require Test::More;

    Test::More::subtest("dir renaming" => sub {
        my %dirs = (
            '2012-03-15' => '120315 -',
            '2012-03-16' => '120316 -',
            'Something'  => undef,
        );
        photo_dir_do(
            items  => [ map { dir($_) } keys %dirs ],
            action => sub {
                my ($old, $new) = @_;

                if(exists $dirs{$old}) {
                    Test::More::is($new, $dirs{$old}, "correct rename $old => $new");
                }
                else {
                    # sanity check - should never happen, unless there is an error in photo_dir_do
                    Test::More::ok(0, "the entry $old was not expected")
                }

                # remove used key, so we can test what remained
                delete $dirs{$old};
            },
        );

        Test::More::is(scalar keys %dirs, 1,               'there is one directory skipped');
        Test::More::is_deeply([keys %dirs], ['Something'], 'the skipped directory is named "Something"');
    });

    Test::More::subtest("bucketize files" => sub {
        my @files = (
            (map { file(sprintf "DSC_9%03d.JPG", $_) } 980 .. 999),
            (map { file(sprintf "DSC_0%03d.JPG", $_) } 0 .. 40),
        );
        my %buck = bucketize_files(@files);
        my @buck_keys = sort keys %buck;
        Test::More::is_deeply([@buck_keys] => [0,9],
            'files are in two groups');
        Test::More::is_deeply([map { scalar @{$buck{$_}} } @buck_keys] => [41,20],
            'number of files in each group is correct');
    });

    Test::More::subtest("buckets calculation" => sub {
        Test::More::is_deeply([bucketize()       ] => [[]],           'bucketize no items');
        for my $i (0..9) {
            Test::More::is_deeply([bucketize($i) ] => [[$i]],         'bucketize single item list');
        }
        Test::More::is_deeply([bucketize(0,9)    ] => [[9], [0]],     'bucketize standard overflow');
        Test::More::is_deeply([bucketize(0,1,9)  ] => [[9], [0,1]],   'bucketize big overflow');
        Test::More::is_deeply([bucketize(0,1,2,9)] => [[9], [0,1,2]], 'bucketize bigger overflow');
        Test::More::is_deeply([bucketize(0,1,8,9)] => [[8,9], [0,1]], 'bucketize long current and big overflow');
        Test::More::is_deeply([bucketize(0,7..9) ] => [[7,8,9], [0]], 'bucketize long current with overflow');
        Test::More::is_deeply([bucketize(7..9)   ] => [[7..9]],       'bucketize no overflow');
        Test::More::is_deeply([bucketize(0..9)   ] => [[0..9]],       'bucketize no overflow full range');
        Test::More::is_deeply([bucketize(0,1, 3,4,5, 7,8,9)] => [[7..9],[0,1,3,4,5]], 'bucketize complex multiple sequences');
    });

    Test::More::done_testing();
    exit;
}
