#include <string>
#include <iostream>

typedef int Type;

auto a = 10;
Type (*fn_ptr)(const int);
Type (*fn_ptr2)(const int, std::string);


void func2(Type (*)(const int, std::string) = fn_ptr2) {};
void func1(Type (*name)(const int) = fn_ptr) {};
void func5(Type (*name)(const int)) {};
void func6(Type (*)(int, bool)) {};
void func3(Type name = a) {};
void func7(Type name) {};
void func4(Type = a) {};
void func8(Type) {};
void func9() {};
void func10(int const thing) { return; }
void func11(const int thing) { return; }

int main(int argc, char *argv[1 + 1])
    {
        std::cout << "done\n";
        return 0;
    }
    
// TODO: add decltype example
// TODO: add templated example
// TODO: add more scope-resolution examples