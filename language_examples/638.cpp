template <int n>
struct S{        
    int foo() requires(n == 2)
    {
        return 2;
    }

        
    int foo() requires(n < 2)
    {
        return 2;
    }

private:
    int b;
};