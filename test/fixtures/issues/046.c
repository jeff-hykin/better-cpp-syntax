/* Forward Declaration */
struct A b;
enum B c;
union C d;

/* Function Declaration */
void a(struct A b);
void b(enum B c);
void c(union C d);
void d(A b);

/* Definition */
struct A {
	enum B c;
	union C d;
};
enum B {
    a, b;
};
union C {
	struct A b;
	enum B c;
};