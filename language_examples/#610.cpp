#include <string>
#include <string_view>

using namespace std::literals::string_view_literals;
using namespace std::literals::string_literals;

const auto view = "Hello"sv;
const auto owned = "Hello"s;
