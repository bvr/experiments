
use Getopt::Std;

sub create_log
{
    BEGIN
    {
        eval
        {
            require Log::Log4perl;
        };
        if( $@ )
        {
            print "Log::Log4perl module not installed - stubbing.\n";
            no strict qw( refs );
            *{"main::$_"} = sub {} for qw( DEBUG INFO WARN ERROR FATAL );
        }
        else
        {
            print "Log::Log4perl module installed.\n";
            # require Log::Log4perl::Level;
            # Log::Log4perl::Level->import( __PACKAGE__ );
            my $conf = q(
                log4perl.category.My.Script = INFO, FileApp, Screen
                log4perl.appender.FileApp = Log::Log4perl::Appender::File
                log4perl.appender.FileApp.mode = append
                log4perl.appender.FileApp.syswrite = 1
                log4perl.appender.FileApp.filename = my.log
                log4perl.appender.FileApp.layout = PatternLayout
                log4perl.appender.FileApp.layout.ConversionPattern = [%p][%d]{%F line %L} %m%n %d> %m%n
                log4perl.appender.Screen = Log::Log4perl::Appender::Screen
                log4perl.appender.Screen.stderr = 0
                log4perl.appender.Screen.layout = Log::Log4perl::Layout::SimpleLayout
            );
            Log::Log4perl->init( \$conf );
        }
    }
}

create_log();
$logger = Log::Log4perl->get_logger( "My::Script" );

$logger->fatal('Stuff');

%month_nums = ("Jan" => 1, "Feb" => 2, "Mar" => 3, "Apr" => 4, May  => 5, "Jun" => 6, "Jul" => 7, "Aug" => 8, "Sep" => 9, "Oct" => 10, "Nov" => 11, "Dec" => 12);
$tries = 1;
$company_fetched = 0;
$logger->logdie( "\n" ) if !getopts( "w:f:", \%options );
$logger->logdie( "Incompatible options." ) if $options{'w'} && $options{'f'};

