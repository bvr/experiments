
use YAPE::Regex::Explain;

print YAPE::Regex::Explain->new(
    qr/^[_a-zA-Z0-9-]+(.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(.[a-zA-Z0-9-]+)*(.[a-zA-Z]{2,3})$/
)->explain;
