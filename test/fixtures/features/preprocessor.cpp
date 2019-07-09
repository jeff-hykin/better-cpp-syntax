#include <iostream>
#include "relative_stuff"


#define a thing {}
#define a(arg1, arg2) arg1 arg2
#define a(arg1, arg2) #macro_variable ##macro_variable

#define thing class Stuff

#define thing struct Stuff 
#define thing struct Stuff \
    {

#define foo namespace foo { struct bar { \
int data, members; \
int other;


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
        {
            
