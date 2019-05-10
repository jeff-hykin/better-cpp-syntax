struct foo {
    int (*bar)();
    int *(*bar)();
    int &(*bar[])();
};

union baz {
    int (*quz)();
};
