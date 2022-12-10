template <class T> struct Explicit {
  T t;
};

template<> struct Explicit<void> {};

extern template struct Explicit<int>;

extern
template
struct Explicit<unsigned>;

template struct Explicit<int>;

template
struct Explicit<unsigned>;
