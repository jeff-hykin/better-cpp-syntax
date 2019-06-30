struct Thing1
{
    Thing1() {
        
    }
};
struct Thing2
{
    explicit Thing2() {
        
    }
};
struct Thing3
{
    virtual ~Thing3() {
        
    }
};
struct Thing4
{
    Thing4();
    ~Thing4();
};

Thing4::~Thing4() {
    itng()
}
Thing4::Thing4() {
    
}


struct Thing5
{
    Thing5() = default;
    ~Thing5() = default;
};

struct Thing6
{
    Thing6() = delete;
    ~Thing6() = delete;
};