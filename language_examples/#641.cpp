#include <iostream>

int main(int argc, const char ** argv)
{
    #ifdef _WIN32
    std::cout << "Hello World Windows" << std::endl;
    #elifdef __linux__
    std::cout << "Hello World Linux" << std::endl;
    #endif
    return 0;
}