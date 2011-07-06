#!/usr/bin/perl

# from http://stackoverflow.com/questions/6341725/perl-deserialize-xml

use strict;
use warnings;

use XML::Twig;
use Test::More tests => 1;

my $expected = {
    my_id   => -31,
    login   => "root",
    ip_list => [
        {   user_ip   => "0.0.0.0",
            user_mask => "0.0.0.0"
        },
        {   user_ip   => "94.230.160.230",
            user_mask => "255.255.255.0"
        }
    ],
    modules => [
        {   module_name => "core" },
        {   module_name => "devices" }
    ],
    addition_modules => []
};

my $data = {};

my $t = XML::Twig->new(
    twig_handlers => {
        'integer[@name="my_id"]' => sub { add_field($data, $_) },
        'string[@name="login"]'  => sub { add_field($data, $_) },
         array                   => sub { array(    $data, @_) },
    },
)->parse(\*DATA);    # replace with parsefile( 'file.xml') to parse a file

is_deeply($data, $expected, 'one test to rule them all');


sub array {
    my ($data, $t, $array) = @_;

    my $name = $array->prev_sibling('integer')->att('name');
    $data->{$name} = [];
    foreach my $item ($array->children('item')) {
        my $item_data = {};
        foreach my $child ($item->children) { add_field($item_data, $child); }
        push @{$data->{$name}}, $item_data;
    }
}

# get a name/value pair of attributes and add it to a hash, which
# could be the overall $data or an element in an array
sub add_field {
    my ($data, $elt) = @_;

    $data->{$elt->att('name')} = $elt->att('value');
}


__DATA__
<data>
    <call function="get_user_data">
        <output>
            <integer name="my_id" value="-31" />
            <string name="login" value="root" />
            <integer name="ip_list" value="2" />
            <array name="i">
                <item>
                    <ip_address name="user_ip" value="0.0.0.0" />
                    <ip_address name="user_mask" value="0.0.0.0"/>
                </item>
                <item>
                    <ip_address name="user_ip" value="94.230.160.230" />
                    <ip_address name="user_mask" value="255.255.255.0"/>
                </item>
            </array>
            <integer name="modules" value="2" />
            <array name="i">
                <item>
                    <string name="module_name" value="core" />
                </item>
                <item>
                    <string name="module_name" value="devices" />
                </item>
            </array>
            <integer name="addition_modules" value="0"/>
            <array name="i"/>
        </output>
    </call>
</data>

