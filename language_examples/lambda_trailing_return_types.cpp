#include <utility>
#include <vector>

namespace boost::asio {
template <typename T>
struct awaitable {};
}

void lambda_trailing_return_types() {
    // #691: the return-type token must not swallow the body or semicolon.
    auto empty = []()->auto{};

    // #704: the body must start even without whitespace before its brace.
    auto add = [&](int a, int b) -> int{
        return a + b;
    };

    auto qualified = []->boost::asio::awaitable<void>{
        return {};
    };

    auto qualified_spaced = []() -> boost::asio::awaitable<void> {
        return {};
    };

    auto nested = []() -> std::vector<std::pair<int, long>>{
        return {};
    };

    auto multiline = []() ->
        boost::asio::awaitable<void>{
        return {};
    };

    auto pointer = []() -> void*{
        return nullptr;
    };

    auto reference = []() -> const int&{
        static const int value = 1;
        return value;
    };

    auto expression = []() -> decltype(1 + 2){
        return 3;
    };
}

#define MAKE_LAMBDA(name) auto name = []()->boost::asio::awaitable<void>{ return {}; }
