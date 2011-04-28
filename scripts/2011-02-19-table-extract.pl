
# http://stackoverflow.com/questions/5050314/lwp-htmltableextract-code-runs-nicely-how-to-apply-some-separators-of-the-t

use strict;
use warnings;
use HTML::TableExtract;
use LWP::Simple;
use Cwd;
use POSIX qw(strftime);

my $te = HTML::TableExtract->new;
my $total_records = 0;
my $suchbegriffe = "e";
my $treffer = 50;
my $range = 0;
my $url_to_process = "http://192.68.214.70/km/asps/schulsuche.asp?q=";
my $processdir = "processing";
my $counter = 50;
my $displaydate = "";
my $percent = 0;

&workDir();
chdir $processdir;
&processURL();
print "\nPress <enter> to continue\n";
<>;
$displaydate = strftime('%Y%m%d%H%M%S', localtime);
open OUTFILE, ">webdata_for_$suchbegriffe\_$displaydate.txt";
&processData();
close OUTFILE;
print "Finished processing $total_records records...\n";
print "Processed data saved to $ENV{HOME}/$processdir/webdata_for_$suchbegriffe\_$displaydate.txt\n";
unlink 'processing.html';
die "\n";

sub processURL() {
print "\nProcessing $url_to_process$suchbegriffe&a=$treffer&s=$range\n";
getstore("$url_to_process$suchbegriffe&a=$treffer&s=$range", 'tempfile.html') or die 'Unable to get page';

   while( <tempfile.html> ) {
      open( FH, "$_" ) or die;
      while( <FH> ) {
         if( $_ =~ /^.*?(Treffer <b>)(d+)( - )(d+)(</b> w+ w+ <b>)(d+).*/ ) {
            $total_records = $6;
            print "Total records to process is $total_records\n";
            }
         }
         close FH;
   }
   unlink 'tempfile.html';
}

sub processData() {
   while ( $range <= $total_records) {
      getstore("$url_to_process$suchbegriffe&a=$treffer&s=$range", 'processing.html') or die 'Unable to get page';
      $te->parse_file('processing.html');
      my ($table) = $te->tables;
      for my $row ( $table->rows ) {
         cleanup(@$row);
         print OUTFILE "@$row\n";
      }
      $| = 1;
      print "Processed records $range to $counter";
      print "\r";
      $counter = $counter + 50;
      $range = $range + 50;
      $te = HTML::TableExtract->new;
   }
}

sub cleanup() {
   for ( @_ ) {
      s/s+/ /g;
   }
}

sub workDir() {
# Use home directory to process data
chdir or die "$!";
if ( ! -d $processdir ) {
   mkdir ("$ENV{HOME}/$processdir", 0755) or die "Cannot make directory $processdir: $!";
   }
}
