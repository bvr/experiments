
package My::TagSet;
use base 'Template::Declare::TagSet';

# returns an array ref for the tag names
sub get_tag_list {
    [ qw(
        app name version eid model
    )]
}


package main;
use 5.010; use strict; use warnings;
use base 'Template::Declare';
use Template::Declare::Tags Foo => { from => 'My::TagSet' };

template input => sub {
    my $self = shift;
    my $version = shift || '1.0.0';

    xml_decl { 'xml', version => '1.0' };
    app {
        version { $version };
        name    { 'ConstDict' };
        eid     { 'E374642' };
        model   { 'PF_RY_WHATEVER' };
    }
};

Template::Declare->init(dispatch_to => ['main']);
say Template::Declare->show('input', 2);
