Item  operator+( const string&  base        , const int&    repetitions ) {};
Item  operator-( const int&     the_input   , const Item&   input_item  ) {};
Item  operator/( const Item&    input_item  , const int&    the_input   ) {};
Item  operator^( const Item&    input_item  , const int&    the_input   ) {};
inline ostream& operator,(ostream& o, ostream& (*manip_fun)(ostream&)) {};

// templated type conversion
operator std::basic_string_view<CharT, Traits>() const noexcept {}

// resolution type conversion
operator std::basic_string_view() const noexcept {}

// implicit conversion
operator std::thing::string() const  {}
operator double() const  {} 


template<typename ElementT> bool operator()(const ElementT& lhs, const ElementT& rhs)
          {
            return std::char_traits<char>::compare(lhs.first, rhs.first, sizeof(lhs.first)) < 0;
          }

// custom literals
void operator "" _km(long double);
void operator "" _km(long double);
std::string operator "" _i18n(const char*, std::size_t);
float operator ""_e(const char*);