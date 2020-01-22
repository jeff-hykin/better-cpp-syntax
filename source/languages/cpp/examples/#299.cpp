enum FOO {
    ONE,
    TWO,
#if COND
    TWO_AND_HALF,
#endif
    THREE
}

#if COND
#define TWO_AND_HALF 1
#endif