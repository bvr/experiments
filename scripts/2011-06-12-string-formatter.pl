
# Simple use -------------------------------------------------------------------

use String::Formatter stringf => {
    codes => {
        s => sub {$_},        # string itself
        l => sub {length},    # length of input string
        e => sub { /[^\x00-\x7F]/ ? '8bit' : '7bit' },    # ascii-safeness
    },
};

print stringf(
    "My name is %s. I am about %l feet tall. I use an %e alphabet.\n",
    'Ricardo', 'ffffff', 'abcchdefghijklmnA±opqrrrstuvwxyz',
);


# Method formatter -------------------------------------------------------------

use DateTime;
use String::Formatter method_stringf => {
  -as => 'datetimef',

  codes => {
    f => 'strftime',
    c => 'format_cldr',
    s => sub { "$_[0]" },
  },
};

print datetimef("%{%Y-%m-%d}f is the same as %{yyyy-MM-dd}c.\n", DateTime->now);


# Format method call results ---------------------------------------------------

use Data::Dump;
use String::Formatter method_stringf => {
    -as   => 'objectf',
    codes => {
        s => sub { my ($obj, $meth) = @_; $obj->$meth(); },
    }
};

use Class::Struct;
struct Product => {
    id    => '$',
    name  => '$',
    price => '$',
};
my $product = Product->new(id => 1, name => 'Stuff', price => 205);

print objectf("Product %{id}s (%{name}s) added for \$%{price}s\n", $product);
