using A = B;
using B = std::C;
using C = decltype(a ? b : c);
struct A {
    using A = B;
    using B = std::C;
    using C = decltype(a ? b : c);
}

void foo() {
    using A = B;
    using B = std::C;
    using C = decltype(a ? b : c);
}