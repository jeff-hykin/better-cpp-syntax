template <typename... Args>
class C {
  static const int count = sizeof...(Args);  // <--
};