
use Data::Dump;
use Log::Dispatchouli::Global '$Logger' => {
    -as  => 'logger',
    init => {
        ident   => 'My::Daemon',
        to_self => 1,
        to_stderr => 1,
        log_pid => 0,
    },
};

$logger->log([ 'some message with data %s', { data => [ 1..5] } ]);
$logger->log('some message2');

section();

$logger->log('whoa');

warn "\nLog dump:\n";
dd $logger->events;


sub section {
    local $logger = $logger->proxy({ proxy_prefix => "[section] " });

    $logger->log('running');

    subsection();

    $logger->log('done');
}

sub subsection {
    local $logger = $logger->proxy({ proxy_prefix => "[subsection] " });

    $logger->log('gathered data');
}
