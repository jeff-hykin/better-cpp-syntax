#include <ctime>
#include <cstdio>
#include <random>


Atype aVar(Atype{1,2,3});

std::mt19937 eng1(std::time(nullptr));
// std::mt19937 eng2(1234);
// int n(1234);
// 3 lines above can all cause the problem

int main()
{
	printf("Hello World!\n");

	return 0;
}