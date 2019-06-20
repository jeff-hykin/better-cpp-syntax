void func()
{
    class var** thing = (class var**)func(); //comment
    struct var** thing = (struct var**)func(); //comment
    enum var** thing = (enum var**)func(); //comment
    union var** thing = (union var**)func(); //comment
}