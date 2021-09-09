#include <ctime>
#include <cstdio>
#include <random>


Atype aVar(Atype{1,2,3});
Atype aVar(new Atype{1,2,3});
Atype aVar(new int(10));
Atype aVar(int(10));
mt19937 gen(time(nullptr) ^ (size_t) new char);


std::mt19937 eng1(std::time(nullptr));
// std::mt19937 eng2(1234);
// int n(1234);
// 3 lines above can all cause the problem

int main()
{
	printf("Hello World!\n");

	return 0;
}