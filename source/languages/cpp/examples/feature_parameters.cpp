#include <string>
#include <iostream>
#include <vector>

typedef int Type;

auto a = 10;
Type (*fn_ptr)(const int);
Type (*fn_ptr2)(const int, std::string);


void func1(Type (*)(const int, std::string) = fn_ptr2) {};
void func2(Type (*name)(const int) = fn_ptr) {};
void func3(Type (*name)(const int)) {};
void func4(Type (*)(int, bool)) {};
void func5(Type name = a) {};
void func6(Type = a ) {};
void func7(Type name) {};
void func8(Type) {};
void func9() {};
void func11( Type (*)(const int, std::string) = fn_ptr2) {};
void func12( Type (*name)(const int) = fn_ptr) {};
void func13( Type (*name)(const int)) {};
void func14( Type (*)(int, bool)) {};
void func15( Type name = a) {};
void func16( Type = a ) {};
void func17( Type name) {};
void func18( Type) {};
void func19() {};
void func20(int const thing) { return; }
void func21(const int thing) { return; }
void func22(decltype(1) thing) { return; }
void func23(const Type) {};
void func24(const int) {};
void func25(short const int) {};
void func26(const short int) {};
void func27(bool (*name)(int, int)) {};

class GameState {};
struct Node {};
enum Thing {};
class Node *exploreTree(class GameState &game, std::vector<int> &searchList) {}
class Node *expandNode(struct Node *nodePtr, class GameState &game, std::vector<int> &searchList) {}
class Node *expandNode(struct Node *nodePtr, enum Thing &game, std::vector<int> &searchList) {}

template<int, typename Callable, typename Ret, typename... Args>
auto internalConversionToFuncPtr(Callable&& a_callable, Ret (*)(Args...)) {}
void failedToLoadCriticalData(const std::string& what, bool throwExcp = false) {}
void failedToLoadCriticalData(const std::string * what, bool throwExcp = false) {}

// beginning of a function
void aFunction(
    int a
);

void func(short a) {
	
}

int main(int argc, char *argv[1 + 1])
    {
        std::cout << "done\n";
        return 0;
    }

// TODO: add [[attribute]] examples