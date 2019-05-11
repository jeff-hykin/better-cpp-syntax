struct foo {
	int (*bar)();
	int *(*bar)();
	int &(*bar[])();
	int **&(*fcnPtr)(int a);
};

union baz {
    int (*quz)();
};
