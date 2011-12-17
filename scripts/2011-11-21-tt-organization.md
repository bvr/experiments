
# Description how to organize web site using TT

*Response from Andy Wardley <abw@wardley.org> on Jun 08, 2010*

I usually have a PRE_PROCESS template (e.g. site/config) which does
something like this:


    [%  USE Date;
        USE YAML;
        USE SomeOtherPlugin;

        PROCESS site/macros;

        site = {
             title     = 'My Site'
             copyright = 'Copyright Me 2010'
             # ...etc...
        }

        page = {
             uri    = template.name
             title  = template.title
             layout = template.layout or 'default'
             # ...etc...
        }
    %]

It loads any plugins I'm using, defines macros (usually via a PROCESS
so I can keep all my macros in one place), a 'site' data structure
containing any sitewide metadata, and 'page' containing metadata
relating to the current page I'm processing.  This information can be
defined in each template using META:

    [% META title  = 'My Page'        # template.title
            layout = 'admin'          # template.layout
    %]

Another approach is to define all the page metadata in a YAML file like
so

    default:
      title: My Default Page
      layout: default

    page1.html:
      title: My First Page
      layout: default

    page2.html:
      title: My Second Page
      layout: fancy

    admin/page1.html:
      title: My Admin Page
      layout: admin

I prefer this approach because it keeps all the metadata in one place
where it's easy to edit.

We then load the info for the relevant page.

    [%  # in site/config
        pages = YAML.undumpfile("$rootdir/metadata/sitemap.yaml");
        page  = pages.${template.name} or pages.default;
    %]

(for persistent servers, e.g. mod_perl, you might want to load and
cache the sitemap YAML in your Perl code and then pass pages to TT to
save loading the YAML on each request).

Then my WRAPPER template (config option: WRAPPER => 'site/wrapper')
does something like this:

    [%  IF page.layout;
            WRAPPER "layout/$page.layout";
                content;
            END;
        ELSE;
            content;
        END
    %]

That processes the correct WRAPPER template to automagically apply
the layout for the page.

You're correct in that WRAPPER works "inside out" so the content is
processed *before* the wrapper.  That means you can't define MACROs
in a WRAPPER and expect them to be visible to the template. But you
can do something similar in the site/config file.  For example, add
a 'config' item to your page metadata and do something like this:

    [%  # load plugins, macros, define site and page as before...

        IF page.config;
            PROCESS "config/$page.config";
        END;
    %]

That'll make sure the correct config/XXX file is loaded before the
template is processed.  Then you just need to define your page-specific
config stuff (macros, plugins, etc) in there.
