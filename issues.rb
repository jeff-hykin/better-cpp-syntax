# fixed
https://github.com/atom/language-c/issues/320
https://github.com/atom/language-c/issues/318
https://github.com/atom/language-c/issues/312
https://github.com/atom/language-c/issues/309
https://github.com/atom/language-c/issues/289
https://github.com/atom/language-c/issues/270
https://github.com/atom/language-c/issues/260
https://github.com/atom/language-c/issues/264
https://github.com/atom/language-c/issues/240
https://github.com/atom/language-c/issues/233
https://github.com/atom/language-c/issues/215
https://github.com/atom/language-c/issues/153
https://github.com/atom/language-c/issues/121
https://github.com/atom/language-c/issues/101

# macro ends early for this case
https://github.com/atom/language-c/issues/307

# hard, wrong tm scope for '>>' in vector<vector<>>
https://github.com/atom/language-c/issues/282

# trigraphs 
```
const char * a = "foo ??/" ??/??/";
```
https://github.com/atom/language-c/issues/273

# hard and provably unfixable, macro conditional seperating closing/opening of non-macro code
I believe the cause of this one is because there is range-matching for `#if` to `#endif`
Im not an expert on TextMate, but I believe ranges can only be nested
range1 start
    range2 start
    range2 end
range1 end
But for this syntax highlighting to work there would need to be overlapping ranges
range1 start
    range2 start
        range1 end
    range2 end
I think even the Tree Sitter would have a very hard time with this 
https://github.com/atom/language-c/issues/269
https://github.com/atom/language-c/issues/290
https://github.com/atom/language-c/issues/280

# hard, meta.processor and meta.struct are never closed
```
#pragma once

#include <type_traits>

#define IsPointDef(...) \
    template<> \
    struct IsPoint<__VA_ARGS__> \
        {\
        static const bool isPoint = true;\
                }

#define ArrayBasedPointDef(T) \
    IsPointDef(T); \
    template<> \
    struct IsArrayBasedPoint<T>:public std::true_type \
        {};



#define XYBasedPointDef(T) \
    IsPointDef(T); \
    template<> \
    struct IsXYBasedPoint<T>:public std::true_type \
{};

#define TypeTAndUIsPoint \
    template<typename T, typename U, class = typename std::enable_if<IsPoint<T>::isPoint>::type, class = typename std::enable_if<IsPoint<U>::isPoint>::type>

namespace Navigation
{
    namespace Utils
    {
        template<typename T>
        struct IsPoint
        {
            static const bool isPoint = false;
        };

        template<typename T>
        struct IsArrayBasedPoint
        {
            static const bool value = false;
        };

        template<typename T>
        struct IsXYBasedPoint
        {
            static const bool value = false;
        };

    }
}
```
https://github.com/atom/language-c/issues/267

# add tagging to ()'s of alignof and sizeof
https://github.com/atom/language-c/issues/246

# intilizier with squiggly brackets instead of ()'s
```
std::string string1{"test"};
```
https://github.com/atom/language-c/issues/236

# no-argument macro's are labeled as functions
```
#define a cout << 's'
```
https://github.com/atom/language-c/issues/197


# the -> is incorrect in global scope
```
_interrupt->fall(this, &Button::trigger);
```
https://github.com/atom/language-c/issues/177


# comments before macros
```
/**/ #define a cout << "this works :/\n";
```
https://github.com/atom/language-c/issues/159

# function pointer syntax support
```
struct foo {
    int (*bar)();
};

union baz {
    int (*quz)();
};
```
https://github.com/atom/language-c/issues/129

# truely unfixable
https://github.com/atom/language-c/issues/118

# namespace resolution multiple inheritace broken
# final/virtual keyword inside of class declare
https://github.com/atom/language-c/issues/81
https://github.com/atom/language-c/issues/169
```
class ClassA {
    
};

class ClassE final : public ClassA {

};

namespace foo {
    class ClassF {

    };

    class ClassG {

    };
}

class ClassH : public foo::ClassF, public foo::ClassG {

};
```

# add std iostream highlighting
cout, cin, cerr etc are not highlighted
https://github.com/atom/language-c/issues/73

# add std vector highlighting
https://github.com/atom/language-c/issues/230

# fixed for C++ but not C
https://github.com/atom/language-c/issues/222
https://github.com/atom/language-c/issues/70