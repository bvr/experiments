
# http://stackoverflow.com/questions/5044200/sqlabstractlimit-failing-at-or-logic

use 5.010; use strict; use warnings;

use SQL::Abstract;

$, = "    ";

my $sql = SQL::Abstract->new;
say $sql->where(
    { -or => [ { field_1 => { 'like', 'John' }},
               { field_2 => { 'like', 'John' }},
             ]
    }, []);


use SQL::Abstract::Limit;

my $sql_and = SQL::Abstract::Limit->new(logic => 'AND');
my $sql_or  = SQL::Abstract::Limit->new(logic => 'OR');

say $sql_and->where(['field_1'=>{'like' => '123'},'field_2'=>{'like'=>'123'}]);
# WHERE ( ( field_1 LIKE ? AND field_2 LIKE ? ) )

say $sql_or->where (['field_1'=>{'like' => '123'},'field_2'=>{'like'=>'123'}]);
# WHERE ( ( field_1 LIKE ? OR field_2 LIKE ? ) )
