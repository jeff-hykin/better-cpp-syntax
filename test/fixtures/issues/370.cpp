struct A {
  template <typename T>
  struct Nested {};
};

template <typename T>
struct B : T::template Nested<int> {};   // <--

B<A> b;