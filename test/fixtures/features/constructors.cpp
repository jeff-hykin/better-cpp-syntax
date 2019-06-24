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
    
}
Thing4::Thing4() {
    
}