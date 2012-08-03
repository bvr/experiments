
use 5.10.1; use strict; use warnings;

use Path::Class;
use aliased 'Path::Class::Rule' => 'Finder';
use List::Util qw(sum);
use Table::Builder;

# gather all words from specified files
my $word_lookup = get_words(
    dir     => dir('TraceIssuesReport'),
    finder  => Finder->new->file->skip_dirs('Backup')->iname('*.vb'),
    verbose => 1,
);


# calculate ratio of words in new files
my $new_dir = dir('d:\\DataDict\\787Tools\\TraceIssuesReport II\\trunk');
my $finder  = Finder->new->file->iname('*.vb');

my $new_table = Table::Builder->new(
    cols => [
        'File',
        'New'    => { align => 'right' },
        'Reused' => { align => 'right' },
        'Ratio'  => {
            label     => 'New %',
            formatter => sub { sprintf "%5.2f%%", $_ },
            inferred  => sub {
                my $self = shift;
                $self->Reused ? 100 * $self->New / $self->Reused : 0
            },
        }
    ]
);

for my $file ($finder->all($new_dir)) {
    my ($reuse, $not) = (0,0);
    for my $word (map { split } $file->slurp(chomp => 1)) {
        if($word_lookup->{$word}) { $reuse++ }
        else                      { $not++   }
    }

    $new_table->add_row($file->relative($new_dir), $not, $reuse);
}
$new_table->add_sep->add_summary_row('Total', (sub { sum @_  }) x 2);

print $new_table->render_as('ascii');


sub get_words {
    my %params = @_;

    # setup finder for files
    my $finder = $params{finder};
    die "\"finder\" parameter has to be specified and subclass of Path::Class::Rule"
        unless $finder && $finder->isa('Path::Class::Rule');

    my $dir = $params{dir} or dir('.');

    my %word_lookup;
    my $table = Table::Builder->new(cols => ['File', 'Words']);
    for my $file ($finder->all($dir)) {
        my @words = map { split } $file->slurp(chomp => 1);
        @word_lookup{@words} = ($file) x @words;
        $table->add_row($file->relative($dir), scalar @words);
    }
    $table->add_sep->add_summary_row('Total', sub { sum @_  });
    print $table->render_as('ascii')
        if $params{verbose};

    return \%word_lookup;
}
