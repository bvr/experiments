
use version; # for version parsing
use subs 'require';
BEGIN {
    sub require {
        warn "use ",version->parse($_[0]);
        # ... emulate original require
    };
}

use 5.12.0;
