use CGI qw(:standard);
use CGI::Carp qw(fatalsToBrowser);
use CGI::Carp qw(warningsToBrowser);
use CGI::Pretty;
use Date::Manip;
use DBI;
use Net::SMTP;
# use MIME::Lite;
use Spreadsheet::WriteExcel;
use Net::Server::Daemonize qw(daemonize);
use File::Copy;
use strict;
use warnings;

my $results_ref;

my $mail_server=`10.0.1.98`;

die $mail_server;

# Get the form contents

my $SPREADSHEET_GEN = new CGI;
	my $request_user =	$SPREADSHEET_GEN -> param('request_user');
	my $raw_user  	=	$SPREADSHEET_GEN -> param('user');
	my $raw_date1 	=	$SPREADSHEET_GEN -> param('date1');
	my $raw_date2 	=	$SPREADSHEET_GEN -> param('date2');
	my $raw_time1	=	$SPREADSHEET_GEN -> param('time1');
	my $raw_time2	=	$SPREADSHEET_GEN -> param('time2');
	my $raw_search	=	$SPREADSHEET_GEN -> param('search');
	my $flag	=	'0';

# Set MySQL variables:
	my $host 	= 	"localhost";
	my $database 	= 	"mysar";
	my $tablename 	= 	"traffic";
	my $dbuser 	= 	"mysar";
	my $dbpw 	= 	"mysar";

# Lower case the username, search:
	$raw_user	=~ 	tr/A-Z/a-z/;
	$raw_search	=~	tr/A-Z/a-z/;

# Clean up username, search:
	$raw_search	=~	/^([\w.:\/]*)$/;
	my $search	=	$1;
	$raw_user	=~	/^([\w ]*)$/;
	my $user	=	$1;

# Add underscore if we were accidentally passed a space:
        $user =~ tr/ /_/;

# fix the dates to MySQL format:
	my $date1 	= 	UnixDate($raw_date1,"%Y-%m-%d");
	my $date2	=	UnixDate($raw_date2,"%Y-%m-%d");
	my $time1	=	UnixDate($raw_time1,"%H:%M:%S");
	my $time2	=	UnixDate($raw_time2,"%H:%M:%S");

# Sanity check on dates, times to keep them in order:
$flag = Date_Cmp($date1,$date2);
        if ($flag>0) {
                ($date1,$date2) = ($date2,$date1);
		($time1,$time2) = ($time2,$time1);
        };

# At this point, all user input is sanitized to some level, right? A smart user can probably still drop the db though.  :(

# Start an HTML table with column headers:
print $SPREADSHEET_GEN->header();
print $SPREADSHEET_GEN->start_html(-title=>'Proxy user report', -style => { -src => '/styles/form.css' },-head=>$SPREADSHEET_GEN->meta({-http_equiv=>"refresh",-content=>"30;URL=http://10.0.12.123/cgi-bin/mysar/proxy_request.cgi"}));
print $SPREADSHEET_GEN->center(img({-src=>'/images/cbj.gif',-alt=>'CBJ'}));
print $SPREADSHEET_GEN->h2("Proxy user report for $user between $date1 $time1 and $date2 $time2");
if ($search ne "") {
        print $SPREADSHEET_GEN->h2("Search string: $search");
};
print $SPREADSHEET_GEN->p("An Excel spreadsheet with the requested information will be mailed to $request_user\@dfckc.com. If you asked for a long term report (more than a few days) it might take up to an hour to generate the report.  Please be patient.");
print $SPREADSHEET_GEN->p(b("Please be extremely careful with this information.  It is highly personal and should not be placed anywhere unauthorized people can see it."));
print $SPREADSHEET_GEN->center(p("[",a({href=>"http://10.0.12.123/cgi-bin/mysar/spreadsheet_request.cgi"},"Spreadsheet"),"]&nbsp;&nbsp;[",a({href=>"http://10.0.12.123/cgi-bin/mysar/proxy_request.cgi"},"User Search"),"]&nbsp;&nbsp;[",a({href=>"http://10.0.12.123/cgi-bin/mysar/ip_request.cgi"},"IP Search"),"]"));
print $SPREADSHEET_GEN->center(hr({-width=>'50%'}),cite("Questions? "),a({-href=>"mailto:jgreene\@dfckc.com?subject=Proxy user results"},"E-mail Jason Greene "),cite("for assistance."),hr({-width=>'25%'}));
print $SPREADSHEET_GEN->end_html;

daemonize(
    'wwwrun',                  # User
    'www',                  # Group
    '/tmp/spreadsheet-child.pid' # Path to PID file
  ) or die "Unable to daemonize spreadsheet request! stopped";

# MySQL connection:
my $db_use  = DBI->connect("DBI:mysql:database=$database;host=$host;port=3306", $dbuser, $dbpw) or die "Database connection not made: $DBI::errstr";

# MySQL query syntax:

my $user_sql=qq(SELECT date, time, INET_NTOA(ip), url, bytes, authuser FROM $tablename WHERE (authuser = ? OR authuser = ?) AND url LIKE ? AND date BETWEEN ? and ? AND DATE_ADD(date, INTERVAL time HOUR_SECOND) BETWEEN CONCAT(?,' ',?) AND CONCAT(?,' ',?) ORDER BY date, time);
my $user_query= $db_use->prepare( $user_sql ) or die($db_use->errstr);


# MySQL query execution.  It is in the until loop to keep Apache from timing out:
$user_query->execute($user, "NT_DOMAIN+$user", "%$search%", $date1, $date2, $date1, $time1, $date2, $time2) or die($user_query->errstr);


# Fill the spreadsheet data with fetchrow:

my $Workbook = Spreadsheet::WriteExcel -> new("/tmp/$user.xls");
my $Worksheet = $Workbook -> add_worksheet("$user report");
my $cntr = 1;					#(start at 1 because 0 is the header row)

my $header_row = $Workbook -> add_format(bold => 1, align => 'center');
my $alternate_row = $Workbook -> add_format(bg_color => 42);

# Prettify the spreadsheet for the user:
$Worksheet->set_column('A:C',15);
$Worksheet->set_column('D:D',60);
$Worksheet->set_column('E:F',15);
$Worksheet->freeze_panes(1, 0);

# Create the header row, one cell at a time:
$Worksheet -> write (0, 0, "Date", $header_row);
$Worksheet -> write (0, 1, "Time", $header_row);
$Worksheet -> write (0, 2, "User\'s IP", $header_row);
$Worksheet -> write (0, 3, "Visited URL", $header_row);
$Worksheet -> write (0, 4, "Bytes", $header_row);
$Worksheet -> write (0, 5, "User", $header_row);

while (my @results = $user_query->fetchrow()) {
	if ( ( $cntr % 2 ) == 0 ) {
		$results_ref = \@results;		#Needed to avoid writing out individual elements
		$Worksheet -> write ($cntr, 0, $results_ref, $alternate_row);
	} else {
		$results_ref = \@results;               #Needed to avoid writing out individual elements
		$Worksheet -> write ($cntr, 0, $results_ref)
	}
	$cntr++;
}
$Workbook -> close;

$db_use->disconnect;

my $xls_size = -s "/tmp/$user.xls";
my $human_xls_size = sprintf("%.2f" , (($xls_size/1024)/1024) );

if ( $xls_size < 10485759 ) {
	my $message = MIME::Lite->new(
		From	=> "$request_user\@dfckc.com",
		To	=> "$request_user\@dfckc.com",
		Subject	=> "Proxy report for $user",
		Type	=> "TEXT",
		Data	=> "Proxy report for $user from $date1 $time1 to $date2 $time2.\nPlease be extremely careful with this information.  It is highly personal and should not be placed anywhere unauthorized people can see it."
		) or die "Failed to create new message ";

	$message->attach(
		Type	=> "application/vnd.ms-excel",
		Path	=> "/tmp/$user.xls",
		Filename => "$user.xls"
	) or die "Failed to attach /tmp/$user.xls" ;

	$message->send('smtp', $mail_server, Timeout=>60) or die "Failed to send message to $request_user" ;
} else {
	copy ("/tmp/$user.xls", "/srv/www/cgi-bin/mysar/spreadsheet/$user.xls");
	my $message = MIME::Lite->new(
		From	=> "$request_user\@dfckc.com",
		To	=> "$request_user\@dfckc.com",
		Subject => "Proxy report for $user",
		Type	=> "TEXT",
		Data	=> "Proxy report for $user from $date1 $time1 to $date2 $time2 is $human_xls_size MB.  The e-mail system will accept a file of maximum 10 MB.  Please retrieve your file from \\\\your_file_server\\proxy\\ as soon as possible.\n\nNote that it will be overwritten without warning if another user requests a report for the same user before you retrieve this file!\n\nAll Excel files are deleted nightly."
	) or die "Failed to send size warning message" ;

	$message->send('smtp', $mail_server, Timeout=>60) or die "Failed to send message to $request_user" ;
};

unlink("/tmp/$user.xls");
unlink '/tmp/spreadsheet-child.pidr';

exit 0;


