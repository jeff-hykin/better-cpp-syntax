class Vector {
private:
    double* elem;           // elem points to an array of sz doubles
    int sz;
public:
    Vector(int s) :elem{new double[s]}, sz{s}       // constructor: acquires resources
    {
        for (int i = 0; i != s; ++i) elem[i] = 0;   // initialize elements
    }

    ~Vector() { delete[] elem; }                    // destructor: release resources

    double& operator[](int i);
    int size() const;
};