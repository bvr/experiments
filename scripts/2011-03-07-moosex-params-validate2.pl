
use MooseX::Declare;
class CheckFields {

    use Moose::Util::TypeConstraints;
    use MooseX::Params::Validate;
    use Try::Tiny;
    use Data::Dump qw(pp);

    subtype 'Email'
        => as 'Str'
        => where {/^(.+)\@(.+)$/};

    method fields() {
        return [
            id    => {isa => 'Int'},
            name  => {isa => 'Str'},
            email => {isa => 'Email'},
        ];
    }

    method queries() {
        return [
            {   'id'    => 1,
                'name'  => 'John Doe',
                'email' => 'john@doe.net'
            },
            {   'id'    => 'John Doe',
                'name'  => 1,
                'email' => 'john.at.doe.net'
            }
        ];
    }

    method validate_fields() {
        my $fields = $self->fields();

        foreach my $query (@{$self->queries}) {
            try {
                my (%params) = validated_hash([%$query], @{$fields});
                warn pp($query) . " - OK\n";
            }
            catch {
                warn pp($query) . " - Failed\n";
            }
        }
    }
}

package main;

CheckFields->new()->validate_fields();
