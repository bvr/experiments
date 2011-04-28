

$userInfo = "firstname\\middlename\\lastname.";


if($userInfo =~ m/\\/){
print("Found it");
}

else{
print("No match found");
}

