
# from http://www.perlmonks.org/?viewmode=public;node_id=703825

=head1 autostopping the debugger

Lets assume, you want to use the debugger. Then the problem might be to get the
debugger to break after a warning condition happened.

The warnings contain a line number which is fine, but when the line is part of
a loop, this is not enough information. We would want a stop with the current
context. Only then can we examine the state of the program in the context that
produced the problem.

So what to do?

I replace the signal handler for SIGWARN with my own handler that checks for
the typical format of a Perl warning. I do that because I am interested only in
warnings from the Perl interpreter. If this format has been detected, the code
branches into a special path where we can setup the debugger. We want the
debugger to stop and to return to the caller, where there warning was caused.
So we set a variable that causes the debugger to stop. This will take effect
when the signal handler has returned. After that setup stage, the warning
message is printed as before the modification.

The signal handler code should go into the debugger initialization
file .perldb. Then I do not have to modify the original source code.

This is the content of file .perldb (place it in the current or in the home
directory):

=cut

sub afterinit {
    $::SIG{'__WARN__'} = sub {
        my $warning = shift;
        if ($warning =~ m{\s at \s \S+ \s line \s \d+ \. $}xms) {
            $DB::single = 1;    # debugger stops automatically after
                                # the line that caused the warning.
        }
        warn $warning;
    };
    print "sigwarn handler installed!\n";
    return;
}
