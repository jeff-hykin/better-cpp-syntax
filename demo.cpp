
#include <iostream>

using namespace std;
// should higlight thing and name
namespace scoped::thing::name {};

// multiple inheritance
struct thing :
    public A,
    public B,
    {};

// operator overloads not marked as functions
int  operator+(string base, int repetitions) {
    return 7;
};

// should higlight the "..."
template<typename... Args>
// should be blue
int iterate(int thing, thing arg2) { }


int main(char arg_num, char** vargs) {
    
    // the and's should all be the same
    int a =  1     and  0;
    int b =  true  and (1);
    int c = (true) and (c > 1);
    
    // member access
    window.MV.translate(0,0.5,0);
    a_pointer.*thread;
    a_pointer->thread;
    a_pointer->*thread;
    a_pointer.thread.thing;
    a_pointer.*thread.*thing;
    data.push_back(c);
    
    // lambda syntax
    auto d = [&, a](thing arg1, thing arg2) -> int {
        return 0;
    }
    
    unsigned long thing        = 100Ul            ;
    auto custom_literal        = 100feet          ;
    auto hex_floating_point    = 0xAB.cdp5        ;
    auto tickmarks_are_allowed = 0x0.53'84'92p10  ;
    // this is messed up because the tick ^ isnt escaped
    // this shouldn't be green
    
    // templated functions
    auto f = bitset(input);
    auto e = bitset<8>(input);
    
    #error Don't make errors
    
    int this_shouldnt_be_green2 = 1;
    return 0;
}