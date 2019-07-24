template <typename T, class Child>
class BaseClass {};

template <typename T>
class ChildClass : public BaseClass<T, ChildClass<T>> {
}; // "BaseClass" colored incorrectly

class OtherChild : public BaseClass<int, OtherChild> {}; // "BaseClass" colored correctly