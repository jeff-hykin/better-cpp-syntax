upcase_in($v1, $v2);  # this changes $v1 and $v2
    sub upcase_in {
	for (@_) { tr/a-z/A-Z/ }
}


($v3, $v4) = upcase($v1, $v2);  # this doesn't change $v1 and $v2
sub upcase {
    return unless defined wantarray;  # void context, do nothing
    my @parms = @_;
    for (@parms) { tr/a-z/A-Z/ }
    return wantarray ? @parms : $parms[0];
}



sub get_line {
	$thisline = $lookahead;  # global variables!
	LINE: while (defined($lookahead = <STDIN>)) {
	    if ($lookahead =~ /^[ \t]/) {
		$thisline .= $lookahead;
	    }
	    else {
		last LINE;
	    }
	}
	return $thisline;
}

&foo(1,2,3);	# pass three arguments
foo(1,2,3);		# the same
foo();		# pass a null list
&foo();		# the same
&foo;		# foo() get current args, like foo(@_) !!
foo;		# like foo() IFF sub foo predeclared, else "foo"


use 5.16.0;
my $factorial = sub {
    my ($x) = @_;
    return 1 if $x == 1;
    return($x * __SUB__->( $x - 1 ) );
};

sub foo :lvalue ($a, $b = 1, @c) { 
    
}

sub foo ($left, $right) {
	return $left + $right;
}
my $auto_id = 0;
sub foo ($thing, $id = $auto_id++) {
    print "$thing has ID $id";
}


sub foo ($thing, @) {
	print $thing;
}

sub foo ($filter, %inputs) {
	print $filter->($_, $inputs{$_}) foreach sort keys %inputs;
}