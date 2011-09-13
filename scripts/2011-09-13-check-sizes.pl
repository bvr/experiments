
use 5.010; use strict; use warnings;
use utf8::all;

use File::Basename qw(fileparse);
use Path::Class;

# configuration
my $pdf_dir   = dir('MDL');
my $model_dir = dir('PDF');

# list of files
my @files =
    grep { -e $_->{mdl} }
    map {
        my $file_noext = fileparse($_, qr/\.[^.]*/);
        my $mdl_file   = $model_dir->file($file_noext.".MDL");

        { pdf => $_, mdl => $mdl_file }
    }
    grep { /\.pdf$/i }
    $pdf_dir->children;

# report sizes of MDL, PDF and ratio
my $table = Table->new;

$table->add_report_bytes(PDF => sub { map { $_->{pdf}->stat->size } @files });
$table->add_report_bytes(MDL => sub { map { $_->{mdl}->stat->size } @files });
$table->add_sep;
$table->add_report(Ratio => sub { map { $_->{mdl}->stat->size / $_->{pdf}->stat->size } @files });

$table->as_box;

BEGIN {
    package Table;
    use base 'ActiveState::Table';

    use Statistics::Descriptive;
    use Number::Format qw(format_number format_bytes);

    our @header = (Min => 0, Q1  => 1, Mean => 2, Q2 => 3, Max => 4);
    our %hdr_hash = @header;

    sub new {
        my $class = shift;
        my $self = bless ActiveState::Table->new => $class;

        # add columns
        $self->add_field('Type');
        my $odd = 0;
        $self->add_field($_) for grep { $odd ^= 1 } @header;

        return $self;
    }

    sub _add_report_format {
        my ($self, $name, $data_cb, $fmt_cb) = @_;
        my $stat = Statistics::Descriptive::Full->new;
        $stat->add_data($data_cb->());
        $self->add_row({
            Type => $name,
            map { $_ => $fmt_cb->($stat->quantile($hdr_hash{$_})) } keys %hdr_hash
        });
    }

    sub add_report       { shift->_add_report_format(@_[0..1], \&format_number) }
    sub add_report_bytes { shift->_add_report_format(@_[0..1], \&format_bytes)  }

    sub as_box {
        my $self = shift;

        $self->SUPER::as_box(
            show_trailer => 0,
            align        => { map { $_ => 'right' } keys %hdr_hash},
            box_chars    => 'unicode'
        );
    }
}

