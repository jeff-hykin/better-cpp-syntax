void function() {
	foo(baz);
	foo((baz));
	foo((bar)baz);
	auto foo = (bar)baz;
	auto foo = new (bar);
	return (bar)0;
}