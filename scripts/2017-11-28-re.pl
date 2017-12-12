
# expand comma separating numbers with comma and space

my $field_value = "123,4,56,12,23,463";
$field_value =~ s/(?<=\d),(?=\d)/, /g;
print $field_value;
