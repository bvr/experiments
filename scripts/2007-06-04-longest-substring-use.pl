
sub find_approx {
	my ($item) = @_;
	my $max = 3;
	for $k (keys %items) {
		$ls = longest_substring($k,$item);
		if(length($ls) > $max) {
			$max = length($ls);
			$found = $k;
		}
	}
	return $found;
}

sub longest_substring {
	my ($str1,$str2) = @_;
	my ($longer,$shorter) = length($str1) > length($str2) ? ($str1,$str2) : ($str2,$str1);
	my $llonger  = length($longer);
	my $lshorter = length($shorter);
	my ($best,$bestpos) = 0;
	
	for $i (0 .. $llonger) {
		for $j (0 .. $lshorter) {
			for $n (0 .. $lshorter - $j) {
				if(substr($longer,$i+$n,1) ne substr($shorter,$j+$n,1)) {
					if($n > $best) { 
						$best = $n;
						$bestpos = $i;
					}
					last;
				}
			}
		}
	}
	return substr($longer,$bestpos,$best);
}
