void f();
namespace A {
	void g();
}
namespace X {
	using a::f;
	using A::g;
} // namespace X
