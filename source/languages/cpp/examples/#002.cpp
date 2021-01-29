#include <string>

class Example {
    Example &operator++();
    operator int();
    operator std::string &();
};

int main() {
    return 0;
}