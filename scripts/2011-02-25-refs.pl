
package Utils;

sub AuthenticateUser {
    my ($user, $passwd, $privs) = @_;
    $res = CGI_ats::GetUserandPasswd($user, $passwd, $privs);
}

package CGI_ats;

sub GetUserandPasswd {
    my ($user, $password, $privs) = @_;

    $$user     = "user_name";
    $$password = "passwd";
    $$privs    = "private";
}

package main;

my ($user, $passwd, $privs);
$res = Utils::AuthenticateUser(\$user, \$passwd, \$privs);

print join("\n", $user, $passwd, $privs), "\n";
