#!d:/Perl/bin/perl.exe

use Mojolicious::Lite;
use Plack::Builder;
use Plack::Handler::FCGI;
use Try::Tiny;

_log("Running");

get '/welcome' => sub {
    my $self = shift;
    $self->render(text => 'Hello Mojo!');
};

_log("Routes");

my $app = builder {
    # enable 'Deflater';
    app->start('psgi');
};

_log("Run server");


try {
my $server = Plack::Handler::FCGI->new();
$server->run($app);
}
catch {
    _log("An error caught: $_");
}

_log("Done");


sub _log {
    open my $out,'>>', 'c:\\Program Files\\Honeywell\\SMV\\htdocs\\smv\\log.txt';
    print {$out} @_,"\n";
    close $out;
}
