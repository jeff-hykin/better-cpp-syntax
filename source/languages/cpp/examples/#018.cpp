void function() {
    typeid(int);
    typeid(long);
    sizeof(1000);
    sizeof(int);
    decltype(int);
    using type = decltype(a_storage_of_callable.callable);
}