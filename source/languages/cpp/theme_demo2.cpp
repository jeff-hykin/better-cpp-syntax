#define show(argument) cout << #argument << "\n";
#define DoubleMax   1.79769e+308
#define Pi          3.1415926535897932384626

Item  func1( const string& base      , const int&  repetitions ) {};
Item  func2( const int&    the_input , const Item& input_item  ) {};
Item  func3( const Item&   input_item, const int&  the_input   ) {};
Item  func4( const Item&   input_item, const int&  the_input   ) {};

Item  operator+( const string&  base        , const int&    repetitions ) {};
Item  operator-( const int&     the_input   , const Item&   input_item  ) {};
Item  operator/( const Item&    input_item  , const int&    the_input   ) {};
Item  operator^( const Item&    input_item  , const int&    the_input   ) {};

int func() {
    01001202
    0b101010
    0xabcdef
    // member access
    a_pointer.thread->*thing;
    a_pointer.*thread->thing;
    a_pointer.thing();
    a_pointer.thing();
    // strings
    "this is a string"
    "and this is a string"
    "and this has escapes \n \t \v"
}

using namespace std;

[[gnu::hot]] [[gnu::const]] [[nodiscard]]
inline int function();

enum      thing1 { definition1,  definition2,  definition3  };
union     thing2 { const float thing1; const double thing2; };
struct    thing3 { const float thing1; const double thing2; };
class     thing3 { const float thing1; const double thing2; };
namespace thing3 { const float thing1; const double thing2; };

int main() {
    // standard inline assembly
    asm(
        "movq $60, %rax\n\t" // the exit syscall number on Linux
        "movq $2,  %rdi\n\t" // this program returns 2
        );
    // templated function calls
    auto thing = aFunction<int>(arguments);
}