template<char C>
struct Example {};
struct Alpha : public Example<'{'> {};
struct Beta {};
int main () {
    int x = 52;
}

template<char C>
struct Example {};
struct Alpha : public Example<'>'> {};
struct Beta {};
int main () {
    int x = 52;
}