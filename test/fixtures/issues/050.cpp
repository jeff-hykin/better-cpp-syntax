void func1();
[[noreturn]] void func2(/*syntax highlighting*/); // no syntax highlighting
void func3();

int main() {
    switch(test) {
        case 1:
        break;
        case 2: [[fallthrough]];
        case 3: break; // no syntax highlighting
    }
    struct st { // syntax highlighting works now
    };
}