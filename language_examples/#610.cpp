#include <string>
#include <string_view>

using namespace std::literals::string_view_literals;
using namespace std::literals::string_literals;

const auto view = "Hello"sv;
const auto owned = "Hello"s;


template <typename T>
struct Wrapper {
  T content;
};

static Wrapper<std::wstring> operator""_wrap(const wchar_t* s, std::size_t n) {
  return {{s, n}};
}
const auto wide_string = L"ws"_wrap;
const auto raw_wide_string = LR"--(rws)--"_wrap;

static Wrapper<char> operator""_wrap(char c) {
  return {c};
}
const auto character = 'c'_wrap;
