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
// operator words
// 
    auto a = 1 and 1;
    auto a = 1 or 1;
    auto a = 1 xor 1;

//
// type castings
//
    dynamic_cast <int> (expression + 1 + thing);
    reinterpret_cast <double> (expression);
    static_cast <Custom> (expression);
    const_cast <int> (expression);
    {
        dynamic_cast <int> (expression + 1 + thing);
        reinterpret_cast <double> (expression);
        static_cast <Custom> (expression);
        const_cast <int> (expression);
    }

//
// Storage types
//
    pthread_rwlockattr_t thing;
    padfthread_rwlockattr_t thing;
    decltype(int);

// 
// operators 
// 
    typeid()
    sizeof()
    alignas()

//
// Memory
//
    auto a = new int(5);
    delete a;
    new (&a_storage_of_callable.callable) type(forward<Callable>(a_callable));
    int *array = new int[100];
    delete[] array;
    char should_always_be_a_newline;
    char deleter;

//
//
// namespaces
//
//
    using namespace std;
    using namespace std;using namespace std;
    using namespace parent_namespace::std;
    
    

    inline namespace {};
    namespace {};
    namespace scoped::console { };
    namespace console {
        template <typename ANYTYPE> void __MAGIC__show(ANYTYPE input) {
                // by default use the stream operator with cout
                std::cout << input;
            }
    }

// 
// Scope resolution
//
    std::cout << input;
    numeric_limits<long double>::infinity();
    char_traits<ANYTYPE>::eof();
    numeric_limits<streamsize>::max();
    Task<ANY_OUTPUT_TYPE, ANY_INPUT_TYPE>::links_to;
    &TEST_CLASS::name;
    Event<ANYTYPE>::   ListenersFor[input_event.name]
    std::allocator_traits<decltype(acopy)>::destroy(acopy, this);
    std::allocator_traits<decltype(acopy)>::deallocate(acopy, this);

//
// member access
//
    window.as.translate(0,0.5,0);
    window.MV.translate(0,0.5,0);
    a_pointer.thread;
    a_pointer.*thread;
    a_pointer->thread;
    a_pointer->*thread;
    a_pointer.thread.thing;
    a_pointer.*thread.*thing;
    a_pointer->thread->thing;
    a_pointer->*thread->*thing;
    a_pointer.thread->*thing;
    a_pointer.*thread->thing;
    a_pointer->thread.*thing;
    a_pointer->*thread.thing;
    a_pointer.thread[0];
    a_pointer.*thread[0];
    a_pointer->thread[0];
    a_pointer->*thread[0];
    a_pointer.thread[0]->*thing;
    a_pointer.*thread[0]->thing;
    a_pointer->thread[0].*thing;
    a_pointer->*thread[0].thing;
    a_pointer.thread();
    a_pointer.*thread();
    ptr_to_original->Start();
    ptr_to_original->*Start();
    a_pointer.thread()->*thing;
    a_pointer.*thread()->thing;
    ptr_to_original->Start().*thing;
    ptr_to_original->*Start().thing;
    {
        a_pointer.thread[0]->*thing;
        a_pointer.*thread[0]->thing;
        a_pointer->thread[0].*thing;
        a_pointer->*thread[0].thing;
        a_pointer.thread;
        a_pointer.*thread;
        a_pointer->thread;
        a_pointer->*thread;
    }
    {
        a_pointer.thread();
        a_pointer.*thread();
        ptr_to_original->Start();
        ptr_to_original->*Start();
    }

//
// Operator keyword
//
    ostream& operator<<(ostream& out, const Item& input_) {};
    Item  operator+( const string&  base        , const int&    repetitions ) {};
    Item  operator-( const int&     the_input   , const Item&   input_item  ) {};
    Item  operator/( const Item&    input_item  , const int&    the_input   ) {};
    Item  operator^( const Item&    input_item  , const int&    the_input   ) {};
    // implicit conversions
    operator std::string() const {};
    operator double() const {};
    // custom literal
    void operator "" _km(long double);

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
    
    
    namespace test {
        template <class T>
        struct test {
            // seperate line template
            template <class U = std::vector<int>>
            template<typename RETURN_TYPE, int N = 0 > 1, typename Callable> 
            bool operator()(U k) {}
        };
        
        struct test2 {
            // same-line template
            template <class U = std::vector<int>>  bool operator()(U k) {}
        };
        
        struct test3 {
            // same-line template
            template <class U = std::vector<int>>  bool operator()(U k) {}
        };
        
        
        struct test2 {
            bool operator()() = delete;
        };
    } // namespace test

    // no syntax highlighting
    class test2 {};
    
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
        template<typename RETURN_TYPE, int N = 0, typename Callable>
        RETURN_TYPE* convertToFunctionPointer(Callable&& c)
            {
                return internalConversionToFuncPtr<N>(forward<Callable>(c), (RETURN_TYPE*)nullptr);
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
    };
    struct Thing2 {
        public:
        public :
        private :
        private:
        protected:
            auto a = 1;
            Thing() {
                
            }
    };

// 
// inheritance
// 

    class foo : private bar,quix,foo, public bar, quix, foo, protected bar, quix{};
    class foo f;
    struct thing : 
        public A, public B {};
        
    class thing :
        public A,
        public B,
        {};


// 
// Functions
// 
    template <class ANYTYPE>
    string ToBinary(ANYTYPE input)
        {
            // depends on #include <bitset>
            return bitset<8>(input).to_string();
        }

//
// lambdas
//
    auto a = [ a, b, c ] 
    (Args... args, int thing1) -> Ret 
        {
        }
        
    [ a,                     b, c ] (Args... args, int thing1) mutable -> Ret {         }
    [ a,                     b, c ] (Args... args, int thing1)                {         }
    [ a = stuff::blah[1324], b, c ] (Args... args, int thing1)                {         }
    [ a,                     b, c ]                                           {         }
    [=]                                                                -> int {         }
    [=]                             ()                         mutable        { return; }
    auto a = thing[1][2];
    auto a = thing()[2];
    [](Args... args) -> Ret {
                return Ret(a_storage_of_callable.callable(forward<Args>(args)...));
            };
            
            
    return [ a, b, c ] (Args... args, int thing1) -> Ret { }
    return [ a, b, c ] -> int { }

    //
    // not lambdas
    //
    test()[0] = 5; // no syntax highlighting;
    test[5][5] = 5;
    
    
    

int main() {
    int a = ( thing + 10)
    return 0;
}