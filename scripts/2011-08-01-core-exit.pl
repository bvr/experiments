
BEGIN { *CORE::GLOBAL::exit = sub { warn "This would normally exit"; }; }

exit;
warn "here";
exit;
warn "still alive";
