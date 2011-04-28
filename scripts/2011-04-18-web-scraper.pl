
use strict; use warnings;
use URI;
use Web::Scraper;
use Data::Dump qw(dump);

my $url = 'http://courses.illinois.edu/cis/2011/spring/schedule/CS/index.html?skinId=2169';

my $courses = scraper {
    process 'div.ws-row',
        'course[]' => scraper {
            process 'div.ws-course-number',  'id'    => 'TEXT';
            process 'div.ws-course-title',   'title' => 'TEXT';
            process 'div.ws-course-title a', 'link'  => '@href';
        };
    result 'course';
};

my $res = $courses->scrape(URI->new($url));

for my $course (@$res) {
    my $crs_scraper = scraper {
        process 'div.ws-description', 'desc' => 'TEXT';
        # ... add more items here
    };
    my $additional_data = $crs_scraper->scrape(URI->new($course->{link}));

    # slice assignment to add them into course definition
    @{$course}{ keys %$additional_data } = values %$additional_data;
}

dump $res;
