#!/usr/bin/env perl

my $ticket = do {
    `git symbolic-ref --short HEAD` =~ /^(\d+)/;
    $1;
};

if ($ticket && ( $ARGV[1] eq '' || $ARGV[1] eq 'message' )) {
    open(my $fh, '+<', $ARGV[0]) or die $!;
    my @message = <$fh>;
    unshift @message, "(refs #$ticket) ";
    seek $fh, 0, 0;
    print $fh @message;
    close $fh;
}

exit 0;
