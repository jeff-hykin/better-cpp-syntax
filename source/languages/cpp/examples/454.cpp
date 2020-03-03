template <typename T>
class RefWrapper {
  operator T&();
  operator const T&();    //  <-- "operator" not highlighted
};