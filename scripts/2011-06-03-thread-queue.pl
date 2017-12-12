
# from http://stackoverflow.com/questions/6221868/perl-and-threads

use strict;
use warnings;

use threads;     #qw( async );
use Thread::Queue qw( );

my $num_workers    = 5;
my $num_work_units = 10;

my $q = Thread::Queue->new();

# Create workers
my @workers;
for (1 .. $num_workers) {
    push @workers, async {
        while (defined(my $unit = $q->dequeue())) {
            print("Processed $unit\n");
        }
    };
}

# Create work
for (1 .. $num_work_units) {
    $q->enqueue($_);
}

# Tell workers they are no longer needed.
$q->enqueue(undef) for @workers;

# Wait for workers to end
$_->join() for @workers;
