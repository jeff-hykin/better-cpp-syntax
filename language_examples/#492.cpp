template <template <typename T> class TT> struct a {};

template <typename T> struct b {};

template <template <typename T> class TT = int> struct c {};

template <template <typename> class TT> struct d {};
