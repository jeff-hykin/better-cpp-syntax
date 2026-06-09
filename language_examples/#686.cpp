int main () {
  auto trivial_lambda_1 = []() static noexcept(true) {};
  auto trivial_lambda_2 = []() mutable noexcept {};
}
