void SomeClass::SomeFunction(const SomeClass& num)
{
    return;
}

SomeClass::SomeClass(SomeClass& a)
{
    return;
}

SomeClass::SomeClass(const SomeClass& num)
{
    this->num = num.num;
}

SomeClass::~SomeClass()
{
}

ns::SomeClass::SomeClass(Thing&& thing)
{
}

ns::SomeClass::~SomeClass()
{
}
