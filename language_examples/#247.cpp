struct foo {
	static_assert(true, "foo");
	static_assert(bar, "bar");
	foo(){}
	int bar(foo bar);
};
