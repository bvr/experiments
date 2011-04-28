
# from http://stackoverflow.com/questions/4982542/how-do-i-split-a-string-into-an-array-by-comma-but-ignore-commas-inside-double-qu

my $string = "Paul,12,\"soccer,baseball,hockey\",white";

my @parts = $string =~ m{
    (   [^,"\\]*                  # unescaped string
      | "(?: [^"]* | \\" )*"    # quoted string
    )
    (?: [,] | \z )              # separator or end of string
}gx;

warn "$_\n" for @parts;
