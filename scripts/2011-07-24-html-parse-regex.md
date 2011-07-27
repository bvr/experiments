*Oh Yes You Can* Use Regexes to Parse HTML!
--------------------------------------
⁠

For the task you are attempting, regexes are **_perfectly fine!_**

It *is* true that most people underestimate the difficulty of parsing HTML with regular expressions and therefore do so poorly.

But this is not some fundamental flaw related to computational theory. That silliness is parroted a lot around here, but don’t you believe them.

 So while it certainly can be done (this posting serves as an existence proof of this incontrovertible fact), that doesn’t mean it **_should_** be.

You must decide for yourself whether you’re up to the task of writing what amounts to a dedicated, special-purpose HTML parser out of regexes. Most people are not.

But *I* am. ☻

-----

EDIT: General Regex-Based HTML Parsing Solutions
---------------------
First I’ll show how easy it is to parse **arbitrary** HTML with regexes. The full program’s at the end of this posting, but the heart of the parser is:

    for (;;) {
      given ($html) {
        last                    when (pos || 0) >= length;
        printf "\@%d=",              (pos || 0);
        print  "doctype "   when / \G (?&doctype)  $RX_SUBS  /xgc;
        print  "cdata "     when / \G (?&cdata)    $RX_SUBS  /xgc;
        print  "xml "       when / \G (?&xml)      $RX_SUBS  /xgc;
        print  "xhook "     when / \G (?&xhook)    $RX_SUBS  /xgc;
        print  "script "    when / \G (?&script)   $RX_SUBS  /xgc;
        print  "style "     when / \G (?&style)    $RX_SUBS  /xgc;
        print  "comment "   when / \G (?&comment)  $RX_SUBS  /xgc;
        print  "tag "       when / \G (?&tag)      $RX_SUBS  /xgc;
        print  "untag "     when / \G (?&untag)    $RX_SUBS  /xgc;
        print  "nasty "     when / \G (?&nasty)    $RX_SUBS  /xgc;
        print  "text "      when / \G (?&nontag)   $RX_SUBS  /xgc;
        default {
          die "UNCLASSIFIED: " .
            substr($_, pos || 0, (length > 65) ? 65 : length);
        }
      }
    }

See how *easy* that is to read?

As written, it identifies each piece of HTML and tells  where it found that piece. You could easily modify it to do whatever else you want with any given type of piece, or for more particular types than these.

 I have no failing test cases (left :): I’ve successfully run this code on more than 100,000 HTML files — every single one I could quickly and easily get my hands on. Beyond those, I’ve also run it on files *specifically constructed* to break naïve parsers.

This is *not* a naïve parser.

Oh, I’m sure it isn’t perfect, but I haven’t managed to break it yet.  I figure that even if something did, the fix would be easy to fit in because of the program’s clear structure. Even regex-heavy programs should have stucture.

Now that that’s out of the way, let me address the OP’s question.

Demo of Solving the OP’s Task Using Regexes
-------------

The little `html_input_rx` program I include below produces the following output, so that you can see that parsing HTML with regexes works just fine for what you wish to do:

    % html_input_rx Amazon.com-_Online_Shopping_for_Electronics,_Apparel,_Computers,_Books,_DVDs_\&_more.htm
    input tag #1 at character 9955:
           class => "searchSelect"
              id => "twotabsearchtextbox"
            name => "field-keywords"
            size => "50"
           style => "width:100%; background-color: #FFF;"
           title => "Search for"
            type => "text"
           value => ""

    input tag #2 at character 10335:
             alt => "Go"
             src => "http://g-ecx.images-amazon.com/images/G/01/x-locale/common/transparent-pixel._V192234675_.gif"
            type => "image"

*Parse Input Tags, See No Evil Input*
-----
Here’s the source for the program that produced the output above.

    #!/usr/bin/env perl
    #
    # html_input_rx - pull out all <input> tags from (X)HTML src
    #                  via simple regex processing
    #
    # Tom Christiansen <tchrist@perl.com>
    # Sat Nov 20 10:17:31 MST 2010
    #
    ################################################################

    use 5.012;

    use strict;
    use autodie;
    use warnings FATAL => "all";
    use subs qw{
        see_no_evil
        parse_input_tags
        input descape dequote
        load_patterns
    };
    use open        ":std",
              IN => ":bytes",
             OUT => ":utf8";
    use Encode qw< encode decode >;

        ###########################################################

                            parse_input_tags
                               see_no_evil
                                  input

        ###########################################################

    until eof(); sub parse_input_tags {
        my $_ = shift();
        our($Input_Tag_Rx, $Pull_Attr_Rx);
        my $count = 0;
        while (/$Input_Tag_Rx/pig) {
            my $input_tag = $+{TAG};
            my $place     = pos() - length ${^MATCH};
            printf "input tag #%d at character %d:\n", ++$count, $place;
            my %attr = ();
            while ($input_tag =~ /$Pull_Attr_Rx/g) {
                my ($name, $value) = @+{ qw< NAME VALUE > };
                $value = dequote($value);
                if (exists $attr{$name}) {
                    printf "Discarding dup attr value '%s' on %s attr\n",
                        $attr{$name} // "<undef>", $name;
                }
                $attr{$name} = $value;
            }
            for my $name (sort keys %attr) {
                printf "  %10s => ", $name;
                my $value = descape $attr{$name};
                my  @Q; given ($value) {
                    @Q = qw[  " "  ]  when !/'/ && !/"/;
                    @Q = qw[  " "  ]  when  /'/ && !/"/;
                    @Q = qw[  ' '  ]  when !/'/ &&  /"/;
                    @Q = qw[ q( )  ]  when  /'/ &&  /"/;
                    default { die "NOTREACHED" }
                }
                say $Q[0], $value, $Q[1];
            }
            print "\n";
        }

    }

    sub dequote {
        my $_ = $_[0];
        s{
            (?<quote>   ["']      )
            (?<BODY>
              (?s: (?! \k<quote> ) . ) *
            )
            \k<quote>
        }{$+{BODY}}six;
        return $_;
    }

    sub descape {
        my $string = $_[0];
        for my $_ ($string) {
            s{
                (?<! % )
                % ( \p{Hex_Digit} {2} )
            }{
                chr hex $1;
            }gsex;
            s{
                & \043
                ( [0-9]+ )
                (?: ;
                  | (?= [^0-9] )
                )
            }{
                chr     $1;
            }gsex;
            s{
                & \043 x
                ( \p{ASCII_HexDigit} + )
                (?: ;
                  | (?= \P{ASCII_HexDigit} )
                )
            }{
                chr hex $1;
            }gsex;

        }
        return $string;
    }

    sub input {
        our ($RX_SUBS, $Meta_Tag_Rx);
        my $_ = do { local $/; <> };
        my $encoding = "iso-8859-1";  # web default; wish we had the HTTP headers :(
        while (/$Meta_Tag_Rx/gi) {
            my $meta = $+{META};
            next unless $meta =~ m{             $RX_SUBS
                (?= http-equiv )
                (?&name)
                (?&equals)
                (?= (?&quote)? content-type )
                (?&value)
            }six;
            next unless $meta =~ m{             $RX_SUBS
                (?= content ) (?&name)
                              (?&equals)
                (?<CONTENT>   (?&value)    )
            }six;
            next unless $+{CONTENT} =~ m{       $RX_SUBS
                (?= charset ) (?&name)
                              (?&equals)
                (?<CHARSET>   (?&value)    )
            }six;
            if (lc $encoding ne lc $+{CHARSET}) {
                say "[RESETTING ENCODING $encoding => $+{CHARSET}]";
                $encoding = $+{CHARSET};
            }
        }
        return decode($encoding, $_);
    }

    sub see_no_evil {
        my $_ = shift();

        s{ <!    DOCTYPE  .*?         > }{}sx;
        s{ <! \[ CDATA \[ .*?    \]\] > }{}gsx;

        s{ <script> .*?  </script> }{}gsix;
        s{ <!--     .*?        --> }{}gsx;

        return $_;
    }

    sub load_patterns {

        our $RX_SUBS = qr{ (?(DEFINE)
            (?<nv_pair>         (?&name) (?&equals) (?&value)         )
            (?<name>            \b (?=  \pL ) [\w\-] + (?<= \pL ) \b  )
            (?<equals>          (?&might_white)  = (?&might_white)    )
            (?<value>           (?&quoted_value) | (?&unquoted_value) )
            (?<unwhite_chunk>   (?: (?! > ) \S ) +                    )
            (?<unquoted_value>  [\w\-] *                              )
            (?<might_white>     \s *                                  )
            (?<quoted_value>
                (?<quote>   ["']      )
                (?: (?! \k<quote> ) . ) *
                \k<quote>
            )
            (?<start_tag>  < (?&might_white) )
            (?<end_tag>
                (?&might_white)
                (?: (?&html_end_tag)
                  | (?&xhtml_end_tag)
                 )
            )
            (?<html_end_tag>       >  )
            (?<xhtml_end_tag>    / >  )
        ) }six;

        our $Meta_Tag_Rx = qr{                          $RX_SUBS
            (?<META>
                (?&start_tag) meta \b
                (?:
                    (?&might_white) (?&nv_pair)
                ) +
                (?&end_tag)
            )
        }six;

        our $Pull_Attr_Rx = qr{                         $RX_SUBS
            (?<NAME>  (?&name)      )
                      (?&equals)
            (?<VALUE> (?&value)     )
        }six;

        our $Input_Tag_Rx = qr{                         $RX_SUBS

            (?<TAG> (?&input_tag) )

            (?(DEFINE)

                (?<input_tag>
                    (?&start_tag)
                    input
                    (?&might_white)
                    (?&attributes)
                    (?&might_white)
                    (?&end_tag)
                )

                (?<attributes>
                    (?:
                        (?&might_white)
                        (?&one_attribute)
                    ) *
                )

                (?<one_attribute>
                    \b
                    (?&legal_attribute)
                    (?&might_white) = (?&might_white)
                    (?:
                        (?&quoted_value)
                      | (?&unquoted_value)
                    )
                )

                (?<legal_attribute>
                    (?: (?&optional_attribute)
                      | (?&standard_attribute)
                      | (?&event_attribute)
                # for LEGAL parse only, comment out next line
                      | (?&illegal_attribute)
                    )
                )

                (?<illegal_attribute>  (?&name) )

                (?<required_attribute> (?#no required attributes) )

                (?<optional_attribute>
                    (?&permitted_attribute)
                  | (?&deprecated_attribute)
                )

                # NB: The white space in string literals
                #     below DOES NOT COUNT!   It's just
                #     there for legibility.

                (?<permitted_attribute>
                      accept
                    | alt
                    | bottom
                    | check box
                    | checked
                    | disabled
                    | file
                    | hidden
                    | image
                    | max length
                    | middle
                    | name
                    | password
                    | radio
                    | read only
                    | reset
                    | right
                    | size
                    | src
                    | submit
                    | text
                    | top
                    | type
                    | value
                )

                (?<deprecated_attribute>
                      align
                )

                (?<standard_attribute>
                      access key
                    | class
                    | dir
                    | ltr
                    | id
                    | lang
                    | style
                    | tab index
                    | title
                    | xml:lang
                )

                (?<event_attribute>
                      on blur
                    | on change
                    | on click
                    | on dbl   click
                    | on focus
                    | on mouse down
                    | on mouse move
                    | on mouse out
                    | on mouse over
                    | on mouse up
                    | on key   down
                    | on key   press
                    | on key   up
                    | on select
                )
            )
        }six;

    }

    UNITCHECK {
        load_patterns();
    }

    END {
        close(STDOUT)
            || die "can't close stdout: $!";
    }


There you go! Nothing to it! :)

Only  **_you_** can judge whether your skill with regexes is up to any particular parsing task. Everyone’s level of skill is different, and every new task is different. For jobs where you have a well-defined input set, regexes are obviously the right choice, because it is trivial to put some together when you have a restricted subset of HTML to deal with. Even regex beginners should be handle those jobs with regexes.  Anything else is overkill.

**However**, once the HTML starts becoming less nailed down, once it starts to ramify in ways you cannot predict but which are perfectly legal, once you have to match more different sorts of things or with more complex dependencies, you will eventually reach a point where you have to work harder to effect a solution that uses regexes than you would have to using a parsing class. Where that break-even point falls  depends again on your own comfort level with regexes.

So What Should I Do?
-----

I’m not going to tell you what you *must* do or what you *cannot* do.  I think that’s Wrong. I just want to present you with possibilties, open your eyes a bit. You get to choose what you want to do and how you want to do it. There are no absolutes — and nobody else knows your own situation as well as you yourself do. If something seems like it’s too much work, well, maybe it is.  Programming should be **_fun_**, you know. If it isn’t, you may be doing it wrong.

One can look at my `html_input_rx` program in any number of valid ways.  One such is that you indeed *can* parse HTML with regular expressions. But another is that it is much, much, much harder than almost anyone ever thinks it is. This can easily lead to the conclusion that my program is a testament to what you should *not* do, because it really is too hard.

 I won’t disagree with that.  Certainly if everything I do in my program doesn’t make sense to you after some study, then you should not be attempting to use regexes for this kind of task. For specific HTML, regexes are great, but for generic HTML, they’re tantamount to madness. I use parsing classes all the time, especially if it’s HTML I haven’t generated myself.

Regexes  optimal for *small* HTML parsing problems,  pessimal for large ones
----


Even if my program is taken as  illustrative of why you should **not** use regexes for parsing general HTML — which is ok, because I kinda meant for it to be that ☺  — it still should be an eye-opener so more people break the terribly common and nasty, nasty habit of writing unreadable, unstructured, and unmaintainable patterns.

Patterns do not have to be ugly, and they do not have to be hard. If you create ugly patterns, it is a reflection on you, not them.

Phenomenally Exquisite Regex Language
---
I’ve been asked to point out that my proferred solution to your problem has been written in Perl. Are you surprised? Did you not notice? Is this revelation a bombshell?

I must confess that I find this request *bizarre in the extreme,* since anybody who can’t figure that out from looking at the very first line of my program surely has other mental disabilities as well.

It is true that not all other tools and programming languages are quite as convenient, expressive, and powerful when it comes to regexes as Perl is. There’s a big spectrum out there, with some being more suitable than others.  In general, the languages that have expressed regexes as part of the core language instead of as a library are easier to work with. I’ve done nothing with regexes that you couldn’t do in, say, PCRE, although you would structure the program differently if you were using C.

Eventually other languages will be catch up with where Perl is now in terms of regexes.  I say this because back when Perl started, nobody else had anything like Perl’s regexes. Say anything you like, but this is where Perl clearly won: everybody copied Perl’s regexes albeit at varying stages of their development.  Perl pioneered almost (not quite all, but almost) everything that you have come to rely on in modern patterns today, no matter what tool or language you use.  So eventually the others *will* catch up.

But they’ll only catch up to where Perl was sometime in the past, just as it is now.  Everything advances.  In regexes if nothing else, where Perl leads, others follow. Where will Perl be once everybody else finally catches up to where Perl is now?  I have no idea, but I know we too will have moved. Probably we’ll be closer to [Perl₆’s style of crafting patterns](http://perlcabal.org/syn/S05.html).

If you like that kind  of thing but would like to use it Perl₅,  you might be interested in [Damian Conway’s **wonderful** Regexp::Grammars](http://search.cpan.org/search?query=regexp+grammars&mode=module) module. It’s completely awesome, and makes what I’ve done here in my program seems just as primitive as mine makes the patterns that people cram together without whitespace or alphabetic identifiers.  Check it out!

---

EDIT: Simple HTML Chunker
----
Here is the complete source to the parser I showed the centerpiece from at the beginning of this posting.

 I am *not* suggesting that you should use this over a rigorously tested parsing class. But I am tired of people pretending that nobody can parse HTML with regexes just because *they* can’t. You clearly can, and this program is proof of that assertion.

Sure,  it isn’t easy, but **it *is* possible!**

And trying to do so is a terrible waste of time, because good parsing classes exist which you *should* use for this task.  The right answer to people trying to parse *arbitrary* HTML is **not** that it is impossible.  That is a facile and disingenuous answer.  The correct and honest answer is that they shouldn’t attempt it because it is too much of a bother to figure out from scratch; they should not  break their back striving to reïnvent a wheel that works perfectly well.

On the other hand, HTML that falls *within a predicable subset* is ultra-easy to parse with regexes. It’s no wonder people try to use them, because for small problems, toy problems perhaps, nothing could be easier. That’s why it’s so important to distinguish the two tasks — specific vs generic — as these do not necessarily demand the same approach.

I hope in the future here to see a more fair and honest treatment of questions about HTML and regexes.

Here’s my HTML lexer.  It doesn’t try to do a validating parse; it just identifies the lexical elements. You might think of it more as **an HTML chunker** than an HTML parser. It isn’t very forgiving of broken HTML, although it makes some very small allowances in that direction.

Even if you never parse full HTML yourself (and why should you? it’s a solved problem!), this program has lots of cool regex bit that I believe a lot of people can learn a lot from.  Enjoy!


    #!/usr/bin/env perl
    #
    # chunk_HTML - a regex-based HTML chunker
    #
    # Tom Christiansen <tchrist@perl.com
    #   Sun Nov 21 19:16:02 MST 2010
    ########################################

    use 5.012;

    use strict;
    use autodie;
    use warnings qw< FATAL all >;
    use open     qw< IN :bytes OUT :utf8 :std >;

    MAIN: {
      $| = 1;
      lex_html(my $page = slurpy());
      exit();
    }

    ########################################################################
    sub lex_html {
        our $RX_SUBS;                                        ###############
        my  $html = shift();                                 # Am I...     #
        for (;;) {                                           # forgiven? :)#
            given ($html) {                                  ###############
                last                when (pos || 0) >= length;
                printf "\@%d=",          (pos || 0);
                print  "doctype "   when / \G (?&doctype)  $RX_SUBS  /xgc;
                print  "cdata "     when / \G (?&cdata)    $RX_SUBS  /xgc;
                print  "xml "       when / \G (?&xml)      $RX_SUBS  /xgc;
                print  "xhook "     when / \G (?&xhook)    $RX_SUBS  /xgc;
                print  "script "    when / \G (?&script)   $RX_SUBS  /xgc;
                print  "style "     when / \G (?&style)    $RX_SUBS  /xgc;
                print  "comment "   when / \G (?&comment)  $RX_SUBS  /xgc;
                print  "tag "       when / \G (?&tag)      $RX_SUBS  /xgc;
                print  "untag "     when / \G (?&untag)    $RX_SUBS  /xgc;
                print  "nasty "     when / \G (?&nasty)    $RX_SUBS  /xgc;
                print  "text "      when / \G (?&nontag)   $RX_SUBS  /xgc;
                default {
                    die "UNCLASSIFIED: " .
                      substr($_, pos || 0, (length > 65) ? 65 : length);
                }
            }
        }
        say ".";
    }
    #####################
    # Return correctly decoded contents of next complete
    # file slurped in from the <ARGV> stream.
    #
    sub slurpy {
        our ($RX_SUBS, $Meta_Tag_Rx);
        my $_ = do { local $/; <ARGV> };   # read all input

        return unless length;

        use Encode   qw< decode >;

        my $bom = "";
        given ($_) {
            $bom = "UTF-32LE" when / ^ \xFf \xFe \0   \0   /x;  # LE
            $bom = "UTF-32BE" when / ^ \0   \0   \xFe \xFf /x;  #   BE
            $bom = "UTF-16LE" when / ^ \xFf \xFe           /x;  # le
            $bom = "UTF-16BE" when / ^ \xFe \xFf           /x;  #   be
            $bom = "UTF-8"    when / ^ \xEF \xBB \xBF      /x;  # st00pid
        }
        if ($bom) {
            say "[BOM $bom]";
            s/^...// if $bom eq "UTF-8";                        # st00pid

            # Must use UTF-(16|32) w/o -[BL]E to strip BOM.
            $bom =~ s/-[LB]E//;

            return decode($bom, $_);

            # if BOM found, don't fall through to look
            #  for embedded encoding spec
        }

        # Latin1 is web default if not otherwise specified.
        # No way to do this correctly if it was overridden
        # in the HTTP header, since we assume stream contains
        # HTML only, not also the HTTP header.
        my $encoding = "iso-8859-1";
        while (/ (?&xml) $RX_SUBS /pgx) {
            my $xml = ${^MATCH};
            next unless $xml =~ m{              $RX_SUBS
                (?= encoding )  (?&name)
                                (?&equals)
                                (?&quote) ?
                (?<ENCODING>    (?&value)       )
            }sx;
            if (lc $encoding ne lc $+{ENCODING}) {
                say "[XML ENCODING $encoding => $+{ENCODING}]";
                $encoding = $+{ENCODING};
            }
        }

        while (/$Meta_Tag_Rx/gi) {
            my $meta = $+{META};

            next unless $meta =~ m{             $RX_SUBS
                (?= http-equiv )    (?&name)
                                    (?&equals)
                (?= (?&quote)? content-type )
                                    (?&value)
            }six;

            next unless $meta =~ m{             $RX_SUBS
                (?= content )       (?&name)
                                    (?&equals)
                (?<CONTENT>         (?&value)    )
            }six;

            next unless $+{CONTENT} =~ m{       $RX_SUBS
                (?= charset )       (?&name)
                                    (?&equals)
                (?<CHARSET>         (?&value)    )
            }six;

            if (lc $encoding ne lc $+{CHARSET}) {
                say "[HTTP-EQUIV ENCODING $encoding => $+{CHARSET}]";
                $encoding = $+{CHARSET};
            }
        }

        return decode($encoding, $_);
    }
    ########################################################################
    # Make sure to this function is called
    # as soon as source unit has been compiled.
    UNITCHECK { load_rxsubs() }

    # useful regex subroutines for HTML parsing
    sub load_rxsubs {

        our $RX_SUBS = qr{
          (?(DEFINE)

            (?<WS> \s *  )

            (?<any_nv_pair>     (?&name) (?&equals) (?&value)         )
            (?<name>            \b (?=  \pL ) [\w:\-] +  \b           )
            (?<equals>          (?&WS)  = (?&WS)    )
            (?<value>           (?&quoted_value) | (?&unquoted_value) )
            (?<unwhite_chunk>   (?: (?! > ) \S ) +                    )

            (?<unquoted_value>  [\w:\-] *                             )

            (?<any_quote>  ["']      )

            (?<quoted_value>
                (?<quote>   (?&any_quote)  )
                (?: (?! \k<quote> ) . ) *
                \k<quote>
            )

            (?<start_tag>       < (?&WS)      )
            (?<html_end_tag>      >           )
            (?<xhtml_end_tag>   / >           )
            (?<end_tag>
                (?&WS)
                (?: (?&html_end_tag)
                  | (?&xhtml_end_tag) )
             )

            (?<tag>
                (?&start_tag)
                (?&name)
                (?:
                    (?&WS)
                    (?&any_nv_pair)
                ) *
                (?&end_tag)
            )

            (?<untag> </ (?&name) > )

            # starts like a tag, but has screwed up quotes inside it
            (?<nasty>
                (?&start_tag)
                (?&name)
                .*?
                (?&end_tag)
            )

            (?<nontag>    [^<] +            )

            (?<string> (?&quoted_value)     )
            (?<word>   (?&name)             )

            (?<doctype>
                <!DOCTYPE
                    # please don't feed me nonHTML
                    ### (?&WS) HTML
                [^>]* >
            )

            (?<cdata>   <!\[CDATA\[     .*?     \]\]    > )
            (?<script>  (?= <script ) (?&tag)   .*?     </script> )
            (?<style>   (?= <style  ) (?&tag)   .*?     </style> )
            (?<comment> <!--            .*?           --> )

            (?<xml>
                < \? xml
                (?:
                    (?&WS)
                    (?&any_nv_pair)
                ) *
                (?&WS)
                \? >
            )

            (?<xhook> < \? .*? \? > )

          )

        }six;

        our $Meta_Tag_Rx = qr{                          $RX_SUBS
            (?<META>
                (?&start_tag) meta \b
                (?:
                    (?&WS) (?&any_nv_pair)
                ) +
                (?&end_tag)
            )
        }six;

    }

    # nobody *ever* remembers to do this!
    END { close STDOUT }
