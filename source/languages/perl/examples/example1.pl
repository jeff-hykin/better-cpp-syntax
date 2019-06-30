#!/usr/bin/perl
use strict;
use warnings;

# check if ruby exists
# check if its version 2.4 or higher
# if it doesn't ex

sub is_a_command{
    my $command_name = $_[0];
    my $output = `command -v $command_name`;
    if ($output =~ /.+/) {
        return $output;
    } else {
        return undef;
    }
}

if ($^O eq "linux") {
    # find the package manager
    system("command -v ruby")
    # system("cat /etc/os-release")
} elsif ($^O eq "darwin") {
    # just run the mac command
    # is_a_command("ruby");
    print(100)
    # system("eval `curl -L git.io/fjBzd`")
} else {
    print "Wtf, what operating system are you running this on?";
}
