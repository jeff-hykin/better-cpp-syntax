// As of Xcode 9.2, optional is still under experimental
using std::experimental::optional;
// Use CFStringRef instead of NSString*, otherwise disable ARC
optional<CFStringRef> optionalString(bool val) {
    optional<CFStringRef> myOptString;
    if(val) {
        // Cast to corresponding CoreFoundation object
        myOptString = (CFStringRef)@"String";
    }
    return myOptString;
}

int main() {
    // value_or() performs nil coalescing, returning the value passed to it if the optional is empty
    auto str = optionalString(false).value_or(CFSTR("Empty"));
    // Cast back to NSString* and print using NSLog()
    NSLog(@"%@", (__bridge NSString*)str); // prints "Empty"
    
    auto vector = std::vector<NSString*>{@"Apple", @"Atom", @"Atari"};
        
    // True
    if (std::all_of(vector.cbegin(), vector.cend(), [](NSString* str){ return [str hasPrefix:@"A"]; })) {
        std::cout << "All strings begin with A\n";
    }
        
    // True
    if (std::any_of(vector.cbegin(), vector.cend(), [](NSString* str){ return [str hasPrefix:@"A"]; })) {
        std::cout << "At least one string begins with A\n";
    }
        
    // False
    if (std::none_of(vector.cbegin(), vector.cend(), [](NSString* str){ return [str hasPrefix:@"A"]; })) {
        std::cout << "None of the strings begin with A\n";
    }
    
    return 0;
}

