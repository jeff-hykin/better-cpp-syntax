#include <vector>

std::vector<uint64_t> test(1 << 22);

int main() {
  for (int i = 0; i < (1 << 22); i++) {
    test[i] = i;
  }
  while (true) {
    switch (test[0] % 4) {
      case 0:
        test[0] = test[0] * 0x5deece66d + 0xb;
        break;
      case 1:
        test[0] = test[0] * 0x5deece66d + 0xb;
        break;
      case 2:
        test[0] = test[0] * 0x5deece66d + 0xb;
        break;
      case 3:
        test[0] = test[0] * 0x5deece66d + 0xb;
        break;
    }
  }
  return 0;
}