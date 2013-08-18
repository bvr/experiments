
package Company::Types;
use Moose::Util::TypeConstraints;

subtype 'Company::Departments', as 'ArrayRef[Company::Department]';
coerce  'Company::Departments', from 'ArrayRef', via {
    require Company::Department;
    [ map { Company::Department->new($_) } @$_ ]
};

subtype 'Company::Persons', as 'ArrayRef[Company::Person]';
coerce  'Company::Persons', from 'ArrayRef', via {
    require Company::Person;
    [ map { Company::Person->new($_) } @$_ ]
};

no Moose::Util::TypeConstraints;

package Company;
use Moose;

has 'id'   => (is => 'ro', isa => 'Num');
has 'name' => (is => 'ro', isa => 'Str');
has 'departments' => (is => 'ro', isa => 'Company::Departments', coerce => 1);

package Company::Department;
use Moose;

has 'id'   => (is => 'ro', isa => 'Num');
has 'name' => (is => 'ro', isa => 'Str');
has 'employees' => (is => 'ro', isa => 'Company::Persons', coerce => 1);

package Company::Person;
use Moose;

has 'id'         => (is => 'ro', isa => 'Num');
has 'first_name' => (is => 'ro', isa => 'Str');
has 'last_name'  => (is => 'ro', isa => 'Str');
has 'age'        => (is => 'ro', isa => 'Num');

package main;

my %hash = (
    company => {
        id => 1,
        name => 'CorpInc',
        departments => [
            {
                id => 1,
                name => 'Sales',
                employees => [
                    {
                        id => 1,
                        name => 'John Smith',
                        age => '30',
                    },
                ],
            },
            {
                id => 2,
                name => 'IT',
                employees => [
                    {
                        id => 2,
                        name => 'Lucy Jones',
                        age => '28',
                    },
                    {
                        id => 3,
                        name => 'Miguel Cerveza',
                        age => '25',
                    },
                ],
            },
        ],
    }
);

my $company = Company->new($hash{company});

use DDP;
p $company;
