
use Log::Dispatchouli;

my $logger = Log::Dispatchouli->new({
    ident     => 'stuff-purger',
    facility  => 'daemon',
    to_stdout => 1,
    debug     => 1,
});

$logger->log(["There are %s items left to purge...", $stuff_left]);
$logger->log_debug("this is extra often-ignored debugging log");
$logger->log_fatal("Now we will die!!");
