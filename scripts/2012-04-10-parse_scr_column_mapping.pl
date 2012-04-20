
use List::MoreUtils qw(firstidx);

while(<DATA>) {
    if(/(\$[a-z_]+) \s* = \s* trim\(\$row\[ (\d+) \]\)/x) {
        $var_in_col{$2} = $1;
    }

    if(/my \@fields = \(qw\((.*?)\)/) {
        @cols = split /\s+/, $1;
    }

    if(/\$ins_sth->execute\((.*)\)/) {
        @var_cols = split /\s*,\s*/, $1;
    }
}

for my $col_num (sort { $a <=> $b } keys %var_in_col) {

    my $var_lookup = $var_in_col{$col_num};
    my $out_col = firstidx { $var_lookup eq $_ } @var_cols;

    printf "[%2d] %-30s %2d %-30s\n", $col_num, $var_in_col{$col_num}, $out_col, $cols[$out_col];
}

__DATA__

    $subproject_name   = trim($row[0]);
    $split_count       = trim($row[1]);
    $scr_number        = trim($row[2]);
    $scr_status        = trim($row[3]);
    $fix_in            = trim($row[4]);
    $severity          = trim($row[5]);
    $load_needed       = trim($row[6]);
    $severity_review   = trim($row[7]);
    $subproject_number = trim($row[8]);
    $scrorig_date      = trim($row[9]);
    $supplier          = trim($row[10]);
    $proj_status       = trim($row[11]);
    $status_details    = trim($row[12]);
    $assignee_name     = trim($row[13]);
    $assign_group      = trim($row[14]);
    $scr_title         = trim($row[15]);
    $change_category   = trim($row[16]);
    $affected_area     = trim($row[17]);
    $customer_number   = trim($row[18]);
    $mfcl_number       = trim($row[19]);

	if ($load_needed eq '') {
		$load_needed = $fix_in;
	}

	if ($scr_number - int($scr_number) != 0) {
		$scr_number = 99999;
	}

	if ($severity_review eq '') {
		$severity_review = '0-Not Approved or Blank';
	}

	if ($severity_review eq '0-Not Approved') {
		$severity_review = '0-Not Approved or Blank';
	}

	if ($project_number eq '19') {
		if ($supplier eq '') {
			$supplier = 'N/A';
		}
	} else {
		$supplier = '-'
	}
	# Make supplier = '-' instead of NULL for vlookups in Excel


	# prepare insert SQL query for mysql
	my @fields = (qw(ReadDate SubProjNumber SubProjName SCRNumber SCRStatus LoadNeeded Severity SeverityReview OrigDate SCRName Supplier ProjStatus StatusDetails AssigneeName AssignGroup SCRTitle ChangeCategory AffectedArea CustomerNumber MFCL));
	my $fieldlist = join ", ", @fields;
	my $field_placeholders = join ", ", map {'?'} @fields;
	my $insert_query = qq{
		INSERT INTO scrsev.scrdata ( $fieldlist ) VALUES ( $field_placeholders )};

	my $ins_sth = $dm->prepare( $insert_query );

	if ($scr_number != 99999) {

	  # create scr name from sub project name and scr number with zeroes left padded to 5 places
	  $scr_name = $subproject_name . "." . sprintf("%05d",$scr_number);

		$ins_sth->execute($ReadDate, $subproject_number, $subproject_name, $scr_number, $scr_status, $load_needed, $severity, $severity_review, $scrorig_date, $scr_name, $supplier, $proj_status, $status_details, $assignee_name, $assign_group, $scr_title, $change_category, $affected_area, $customer_number, $mfcl_number)
			or die "Execute failed:  $DBI::errstr";


