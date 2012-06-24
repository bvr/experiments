use Pithub;
use Data::Printer;

my $p = Pithub->new;
for my $user (qw(miyagawa stevan rjbs rafl yanick frioux)) {

    warn ">>> $user\n";
    mkdir $user unless -d $user;

    my $result = $p->repos->list(user => $user);
    $result->auto_pagination(1);

    while (my $row = $result->next) {
        warn sprintf "[%3d] %s%s\n", ++$i, $row->{name}, $row->{fork} ? ' (fork)' : '';

        next if $row->{fork};
        next if -d "$user/$row->{name}";

        system "git clone $row->{clone_url} $user/$row->{name}";
    }
}
