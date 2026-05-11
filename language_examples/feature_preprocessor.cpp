#include <iostream>
#include "relative_stuff"


#define a thing {}
#define a(arg1, arg2) arg1 arg2
#define a(arg1, arg2) #macro_variable ##macro_variable

#define thing class Stuff

#ifdef __vax__
#error "Won't work on VAXen.  See comments at get_last_object."
#endif

#if !defined(FOO) && defined(BAR)
#error 'BAR requires FOO.'
#endif

#ifdef __vax__
#warning "Won't work on VAXen.  See comments at get_last_object."
#endif

#if !defined(FOO) && defined(BAR)
#warning 'BAR requires FOO.'
#endif

#define thing struct Stuff 
#define thing struct Stuff \
    {

#define foo namespace foo { struct bar { \
int data, members; \
int other;


#pragma once

#pragma GCC poison printf 

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
            

#define thing /*
    this should be a comment
*/

#if thing /*
    this should be a comment
*/

#define test test2 /* line 1
          The timeout is set to 5x to ensure we don't timeout too early. */

/* test comment */
typedef enum{
    A= 0,
    B= 1
} BB;