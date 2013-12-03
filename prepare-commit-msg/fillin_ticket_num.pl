#! /usr/bin/env perl
use Path::Class qw(file);

my $ticket = do {
    `git symbolic-ref --short HEAD` =~ /^(\d+)/;
    $1;
};

if ($ARGV[1] eq '' && $ticket) {
    my $prepared_msg = file($ARGV[0])->slurp;
    my $writer = file($ARGV[0])->open('w') or die $!;
    $writer->print("(refs #$ticket) ", $prepared_msg);
    $writer->close;
}
