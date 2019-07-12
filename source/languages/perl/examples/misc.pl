#!/usr/bin/perl
use strict;
use warnings;


sub readFileAsString {
    use FindBin qw( $RealBin );
    # Get arugments
    my ($file_relative_path) = @_; 
    
    open(my $fh, '<:encoding(UTF-8)', "$RealBin/$file_relative_path") or die "Could not open file '$file_relative_path' $!";
    my $text = "";
    while (my $row = <$fh>) {
        $text = "$text$row";
    }
    return $text;
}

sub is_a_command {
    my $command_name = $_[0];
    my $output = `command -v $command_name`;
    if ($output =~ /.+/) {
        return $output;
    } else {
        return undef;
    }
}

use LWP::Simple;

use LWP::UserAgent qw();
my $ua = LWP::UserAgent->new;
my $res = $ua->mirror(
    "https://www.google.com",
    "/Users/jeffhykin/setup.pl",
);
if ($res->is_error) {
    printf(
        "mirror failed.\nStatus: %s\nContent:\n%s\n\nFull response:\n%s\n",
        $res->status_line,
        $res->content,
        $res->as_string
    )
}

print getstore("https://www.google.com", "/Users/jeffhykin/setup.pl");