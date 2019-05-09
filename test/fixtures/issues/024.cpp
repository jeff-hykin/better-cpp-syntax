class ClassA {    
};

class ClassE final : public ClassA {
};

namespace foo {
    class ClassF {
    };

    class ClassG {
    };
}

class ClassH : public foo::ClassF, public foo::ClassG {
};