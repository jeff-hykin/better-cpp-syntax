int main()
{
    constexpr std::size_t highlight{};
    const ::std::size_t highlight2{};
    ::std::size_t const highlight3{};
    ::std::size_t constexpr highlight4{};
    constexpr ::std::size_t no_highlight{};
}