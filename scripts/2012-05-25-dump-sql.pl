
# from http://blogs.perl.org/users/ovid/2010/08/pretty-sql-output-on-test-failure.html

sub dump_sql {
    my ($sql, $arguments) = @_;

    eval "use Regexp::Common 'RE_quoted'";

    # Reformat the SQL and arguments
    my $re_quoted = RE_quoted();
    unless ($@) {
        my @sql = split /($re_quoted)/ => $sql;
        foreach (@sql) {
            next if /$re_quoted/;
            s/((?:LEFT )?(?:OUTER )?JOIN|AND)/\n      $1/g;
            s/(FROM|WHERE|(?:GROUP|ORDER) BY)/\n  $1/g;
            s/,/,\n    /g unless /$re_quoted/;
        }
        $sql = join '' => @sql;

        # this works because the arguments are actually the bind parameters
        # pulled from an SQL log. Season to taste
        my @arguments = split /($re_quoted)/ => $arguments;
        foreach (@arguments) {
            s/,/,\n  /g unless /$re_quoted/;
        }
        $arguments = join '' => @arguments;
    }

    # syntax highlight it
    eval <<'  END';
  use Syntax::Highlight::Engine::Kate::SQL_MySQL;
  END
    unless ($@) {
        my $hl = Syntax::Highlight::Engine::Kate::SQL_MySQL->new(
            format_table => {
                'Keyword'      => [GREEN,   RESET],
                'Comment'      => [BLUE,    RESET],
                'Data Type'    => [WHITE,   RESET],
                'Decimal'      => [YELLOW,  RESET],
                'Float'        => [YELLOW,  RESET],
                'Function'     => [CYAN,    RESET],
                'Identifier'   => [RED,     RESET],
                'Normal'       => [MAGENTA, RESET],
                'Operator'     => [CYAN,    RESET],
                'Preprocessor' => [RED,     RESET],
                'String'       => [RED,     RESET],
                'String Char'  => [RED,     RESET],
                'Symbol'       => [CYAN,    RESET],
            }
        );
        $sql = $hl->highlightText($sql);
    }

    explain <<"  END";
SQL:

  $sql

ARGUMENTS:

  $arguments
-------------------
  END
}
