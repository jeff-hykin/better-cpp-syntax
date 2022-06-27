struct S {
  int x1 =
      f(R"(some raw string literal)");
  int x2 =
      f( R"(some raw string literal)");
  int x3 =
      f(g(R"(some raw string literal)"));
  int y = 100;
  const char* z = "hello";
};