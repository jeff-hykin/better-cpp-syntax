class Base
{
  public:
    virtual void method() const = 0;
}
class Derived : public Base
{
  public:
    virtual void method() const override = 0;
}
