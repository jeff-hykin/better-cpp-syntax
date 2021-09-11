template <typename T>
class BaseClass {
  protected:
	// no instantiation of this base class
	BaseClass(bool argOne, bool argOther) : m_one(argOne), m_other(argOther) {}

	bool m_one, m_other;
};

class ThisTest : public BaseClass<ThisTest> {
	ThisTest()
	    : someMember(true), // here is a comment that is colored nicely!
	      anotherOne(false), quiteALotOfMembers(false), // here's another one!
	      soManyThatTheConstructorIsLong(true), iMeanReallyLong(false),
	      BaseClass<ThisTest>(true, false) { // this constructor call doesn't look good
	}

	bool someMember;
	bool anotherOne;
	bool quiteALotOfMembers;
	bool soManyThatTheConstructorIsLong;
	bool iMeanReallyLong;
};
