
package Capture;
use Moose;
use Carp;

has _buffer     => ( is => 'rw', isa => 'ScalarRef' );
has _old_stdout => ( is => 'rw', isa => 'FileHandle' );

    sub buffer {
        my $self = shift;
        return ${$self->_buffer}
    }

sub capture {
    my $self = shift;
    my $old_stdout;
    my $buffer;

    open $old_stdout, '>&', STDOUT
        or croak 'Cannot duplicate filehandle';

    close STDOUT;

    open STDOUT, '>', \$buffer
        or croak 'Cannot open filehandle';

    $self->_old_stdout( $old_stdout );
    $self->_buffer( \$buffer );
}

sub reset {
    my $self = shift;

    open STDOUT, '>&', $self->_old_stdout
        or croak 'Cannot reset STDOUT';
}

package main;

my $stdout = Capture->new();
$stdout->capture();
print "Some output\n";
$stdout->reset();

print $stdout->buffer();        # Some output
