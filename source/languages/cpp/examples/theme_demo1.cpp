using namespace std;

template <class ANYTYPE>
void thing(int a, Blah other_thing, double c=10, ANYTYPE f) {
    return;
}

int operator^(double a, double b) {
    cout << "testing";
    return 0;
}

int main(char arg_num, char** vargs) {
    if (     1 and 0       ) cout << "this is the and operator\n";
    if (  true and (c > 1) ) cout << "this is the and operator\n";
    if ((true) and (c > 1) ) cout << "this is still the and operator\n";
    
    #error I should be able to write single quotes in here: Don't make errors
}