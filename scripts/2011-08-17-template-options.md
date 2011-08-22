For [CPAN](http://search.cpan.org) offerings have a look at the following (in
alphabetical order)...

* [Builder](http://search.cpan.org/dist/Builder/)
* [HTML::AsSubs](http://search.cpan.org/dist/HTML-Tree/lib/HTML/AsSubs.pm)
* [HTML::Tiny](http://search.cpan.org/dist/HTML-Tiny/)
* [Markapl](http://search.cpan.org/dist/Markapl/)
* [Template::Declare](http://search.cpan.org/dist/Template-Declare/)
* [XML::Generator](http://search.cpan.org/dist/XML-Generator/)

Using the table part of the CL-WHO example provided (minus Roman numerals and
s/background-color/color/ to squeeze code into screen width here!)....


Builder
-------

    use Builder;
    my $builder = Builder->new;
    my $h = $builder->block( 'Builder::XML' );

    $h->table( { border => 0, cellpadding => 4 }, sub {
       for ( my $i = 1; $i < 25; $i += 5 ) {
           $h->tr( { align => 'right' }, sub {
               for my $j (0..4) {
                   $h->td( { color => $j % 2 ? 'pink' : 'green' }, $i + $j );
               }
           });
       }
    });

    say $builder->render;


HTML::AsSubs
------------

    use HTML::AsSubs;

    my $td = sub {
        my $i = shift;
        return map {
            td( { color => $_ % 2 ? 'pink' : 'green' }, $i + $_ )
        } 0..4;
    };

    say table( { border => 0, cellpadding => 4 },
        map {
            &tr( { align => 'right' }, $td->( $_ ) )
        } loop( below => 25, by => 5 )
    )->as_HTML;



HTML::Tiny
----------

    use HTML::Tiny;
    my $h = HTML::Tiny->new;

    my $td = sub {
        my $i = shift;
        return map {
            $h->td( { 'color' => $_ % 2 ? 'pink' : 'green' }, $i + $_ )
        } 0..4;
    };

    say $h->table(
        { border => 0, cellpadding => 4 },
        [
            map {
                $h->tr( { align => 'right' }, [ $td->( $_ ) ] )
            } loop( below => 25, by => 5 )
        ]
    );


Markapl
-------

    use Markapl;

    template 'MyTable' => sub {
        table ( border => 0, cellpadding => 4 ) {
           for ( my $i = 1; $i < 25; $i += 5 ) {
               row ( align => 'right' ) {
                   for my $j ( 0.. 4 ) {
                       td ( color => $j % 2 ? 'pink' : 'green' ) { $i + $j }
                   }
               }
           }
        }
    };

    print main->render( 'MyTable' );



Template::Declare
-----------------

    package MyTemplates;
    use Template::Declare::Tags;
    use base 'Template::Declare';

    template 'MyTable' => sub {
        table {
            attr { border => 0, cellpadding => 4 };
            for ( my $i = 1; $i < 25; $i += 5 ) {
                row  {
                    attr { align => 'right' };
                        for my $j ( 0..4 ) {
                            cell {
                                attr { color => $j % 2 ? 'pink' : 'green' }
                                outs $i + $j;
                            }
                        }
                }
            }
        }
    };

    package main;
    use Template::Declare;
    Template::Declare->init( roots => ['MyTemplates'] );
    print Template::Declare->show( 'MyTable' );


XML::Generator
--------------

    use XML::Generator;
    my $x = XML::Generator->new( pretty => 2 );

    my $td = sub {
        my $i = shift;
        return map {
            $x->td( { 'color' => $_ % 2 ? 'pink' : 'green' }, $i + $_ )
        } 0..4;
    };

    say $x->table(
        { border => 0, cellpadding => 4 },
        map {
            $x->tr( { align => 'right' }, $td->( $_ ) )
        } loop( below => 25, by => 5 )
    );




*And the following can be used to produce the "loop" in HTML::AsSubs /
HTML::Tiny / XML::Generator examples....*

    sub loop {
        my ( %p ) = @_;
        my @list;

        for ( my $i = $p{start} || 1; $i < $p{below}; $i += $p{by} ) {
            push @list, $i;
        }

        return @list;
    }


/I3az/
