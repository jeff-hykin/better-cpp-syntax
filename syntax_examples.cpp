#include <iostream>
#include <sstream>
//
//
// Constants
//
//

    //
    // Digits
    //
        // decimal
            1
            .1
            .239480
            .239480f
            0.
            0.f
            0.L
            0.LL
            4897430la
            32094.930123a
            4897430LL
            32094.930123F
            32094.930123f
            1'03'432'43
            123232'1231321
            3'20'94.93'01'23
            3'20'94.93'1'23
        // e
            0e1
            1e10f
            1.e10
            1.e10
            1.e-10
            1.79769e+308
            1.79'76'9e+3'0'8
        // octal
            01
            01001202
            010'0'120'2
            0'1'2'3'4
        // binary
            0b101010
            0b000001
            0b100001
            0b1'01'010
            0b1'00'001
        // hex
            0x01
            0xabcdef
            0xaBCDEf
            0xABCDEF
            0xAB.cdp5f
            0xAB.cdp5l
            0x20394afLL
            0x01
            0xabc'def
            0xa'BC'DEf
            0xABC'DEF
            0x20'394'a'fLL
        // hex floating point literal
            0x0.5p10F
            0x0.5p10f
            0x1ffp10
            0x0.23p10
            0x0.234985p10L
            0x139804.234985p10L
            0x0.53'84'92p10
            0x5.p10
            0x0.23p+10
            0x0.234985p+10L
            0x139804.234985p-10L
            0x0.53'84'92p-10
            0x5.p+10
            0x13'98'04.234985p10L
        // custom literals
            29042ms
            0xabcdefmm
            0xabc'defmm
            0xabcdefyards
            20ounces
            2000miles
            L"akdjfhald"
            
    //
    // chars
    //
        '1'
        'a'
        '\n'
        '\0'
    //
    // Strings
    //
        auto a = "things\n\b\v\t";
//
// Memory
//
    auto a = new int(5);
    delete a;
    int *array = new int[100];
    delete[] array;

//
//
// namespaces
//
//
using namespace std;
using namespace parent_namespace::std;

namespace {}
namespace scoped::console { }
namespace console {
    template <typename ANYTYPE> void __MAGIC__show(ANYTYPE input) {
            // by default use the stream operator with cout
            std::cout << input;
        }
}

//
//
// preprocessor
//
//
#define Infinite    numeric_limits<long double>::infinity()
#define DoubleMax   1.79769e+308
#define Pi          3.1415926535897932384626
#define show(argument) cout << #argument << "\n";
#ifndef CEKO_LIBRARY
#define CEKO_LIBRARY
#endif

//
// templates
//
template<int, typename Callable, typename Ret, typename... Args>
auto internalConversionToFuncPtr(Callable&& a_callable, Ret (*)(Args...))
    {
        static bool used = false;
        static storage<Callable> a_storage_of_callable;
        using type = decltype(a_storage_of_callable.callable);

        if(used) {
            a_storage_of_callable.callable.~type();
        }
        new (&a_storage_of_callable.callable) type(forward<Callable>(a_callable));
        used = true;
        // lambda 
        return [](Args... args) -> Ret {
            return Ret(a_storage_of_callable.callable(forward<Args>(args)...));
        };
    }


// 
// Classes
//
class Thing {
    public:
    public :
    private :
    private:
    protected:
        auto a = 1;
    Thing() {
        
    }
}
int main() {
    return 0;
}