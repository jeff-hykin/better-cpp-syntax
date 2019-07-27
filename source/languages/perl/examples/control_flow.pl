do {
    my $val = $array[$idx];
    local  $array[$idx];
    delete $array[$idx];
    $val
}

LINE: while (defined($lookahead = <STDIN>)) {
    if ($lookahead =~ /^[ \t]/) {
    $thisline .= $lookahead;
    }
    else {
    last LINE;
    }
}

print "FROBNITZ DETECTED!\n" if $is_frobnitz;
die "BAILING ON FROBNITZ!\n" unless $deal_with_frobnitz;


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


while (my $line = <>) {
    $line = lc $line;
} continue {
    print $line;
}

BEGIN {
	my $secret_val = 0;
	sub gimme_another {
	    return ++$secret_val;
	}
}
