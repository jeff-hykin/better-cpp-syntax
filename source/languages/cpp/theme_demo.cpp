#define show(argument) cout << #argument << "\n";

using namespace std;

// attributes
[[gnu::hot]] [[gnu::const]] [[nodiscard]] inline int f();

int func(Ret (*a_func_ptr)(Args...)) {
    auto a = 0xabcdefyards;
    auto c = 0'1'2'3'4;
    a_pointer.thread->*thing;
    a_pointer.*thread->thing;
    a_pointer->thread.*thing;
    a_pointer->*thread.thing;
}

Item  operator+( const string&  base        , const int&    repetitions ) {};
Item  operator-( const int&     the_input   , const Item&   input_item  ) {};
Item  operator/( const Item&    input_item  , const int&    the_input   ) {};
Item  operator^( const Item&    input_item  , const int&    the_input   ) {};

enum enum1 { definition1, definition2, definition3 }

int main() {
    // standard inline assembly
    asm(
        "movq $60, %rax\n\t" // the exit syscall number on Linux
        "movq $2,  %rdi\n\t" // this program returns 2
        );
    // lambda functions
    auto a_lambda = [ a, b, c ] (Args... args, int thing1) -> Ret 
        {
            cout << "hello";
        };
    // templated function calls
    auto thing = aFunction<int>(arguments);
}