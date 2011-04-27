
# ikegami: http://stackoverflow.com/questions/5208216/threading-taking-up-large-amounts-of-cpu/5226800#5226800

my $q = Thread::Queue->new();

my @workers;
for (1..$MAX_WORKERS) {
    push @workers, async {
       while (my $job = $q->dequeue()) {
           ...
       }
    };
}

for (...) {
    $q->enqueue(...);
}

# Time to exit
$q->enqueue(undef) for 0..$#workers;

# Wait for workers to finish.
$_->join() for @workers;

