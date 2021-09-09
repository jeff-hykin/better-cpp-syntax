extern "C" { // this one is okay
    void inBlock()
    {}
}

extern "C" void inBlock() // this one is not
{
    
}