#define SOME_MACRO 1

struct SSomeStruct {
	SSomeStruct() :
		foo(0)

		#if SOME_MACRO
			, bar(0)
		#endif // SOME_MACRO
	{}

	public:
		int foo;

		#if SOME_MACRO
			int bar;
		#endif // SOME_MACRO
};
