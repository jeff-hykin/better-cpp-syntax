int main() {
    switch(test) {
        case 1:
        break;
        case 2: [[fallthrough]];
        case 3: break; // no syntax highlighting
    }
    void func1();
    [[noreturn]] void func2(/*syntax highlighting*/); // no syntax highlighting
    struct st { // syntax highlighting works now
    };
    void func3();
}
