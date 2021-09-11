constexpr A *__A() {
	return A() ? A::get<0>(A)._l.A
                 : A::A(A::get<0>(A)._s.A[0]);
}
constexpr void func() {
}