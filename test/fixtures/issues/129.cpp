void function() {
    new Foo;
    new (Foo);
    new (fooptr) Foo;
    new (fooptr) (Foo);

}