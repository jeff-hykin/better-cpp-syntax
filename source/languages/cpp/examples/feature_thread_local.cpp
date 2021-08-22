#include <thread>

int foo() {
    static thread_local int bar = 1;
    return bar;
}