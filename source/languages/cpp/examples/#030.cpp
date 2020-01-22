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