struct A {
    int a;
    int b;
    usertype user_value;
    usertype user_value{'A'};
    int a[] = {1,2,3};
    scoped::templated<type> value;
    compound<typename templated::type *>::type value;
};

int a;
int b;
usertype user_value;
usertype user_value{'A'};
scoped::templated<type> value;
compound<typename templated::type *>::type value;
int a[] = {1,2,3};
function_declaration(int *, usertype user_value);

int main() {
    int* a;
    int b;
    usertype user_value[] = {1,2,3};
    usertype* user_value[] = {1,2,3};
    usertype* user_value[1];
    usertype user_value{'A'};
    scoped::templated<type> value;
    compound<typename templated::type *>::type value;
    int a[] = {1,2,3};
    function_declaration(int *, usertype user_value);
}