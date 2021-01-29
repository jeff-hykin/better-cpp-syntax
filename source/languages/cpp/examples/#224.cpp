int main() {
    for (const auto &[a, b] : c)
        a->bug(bug); // bug
    for (const auto [a, b] : c)
        a->bug(bug); // bug
}
