class Base {
    virtual ~Base() = default;
}

class Derived:Base {
    ~Derived() override = default;
}